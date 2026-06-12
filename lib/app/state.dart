import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../repositories/mock_repository.dart';

final repositoryProvider = Provider<MockRepository>((ref) => MockRepository());

class AppSettings {
  const AppSettings({required this.locale, required this.themeMode});
  final Locale locale;
  final ThemeMode themeMode;

  AppSettings copyWith({Locale? locale, ThemeMode? themeMode}) {
    return AppSettings(locale: locale ?? this.locale, themeMode: themeMode ?? this.themeMode);
  }
}

class SessionState {
  const SessionState({
    required this.settings,
    required this.profile,
    required this.esim,
    required this.participants,
    required this.orders,
    required this.didFinishOnboarding,
    required this.isLoaded,
  });

  final AppSettings settings;
  final UserProfile profile;
  final EsimProfile esim;
  final Map<String, int> participants;
  final List<GroupOrder> orders;
  final bool didFinishOnboarding;
  final bool isLoaded;

  SessionState copyWith({
    AppSettings? settings,
    UserProfile? profile,
    EsimProfile? esim,
    Map<String, int>? participants,
    List<GroupOrder>? orders,
    bool? didFinishOnboarding,
    bool? isLoaded,
  }) {
    return SessionState(
      settings: settings ?? this.settings,
      profile: profile ?? this.profile,
      esim: esim ?? this.esim,
      participants: participants ?? this.participants,
      orders: orders ?? this.orders,
      didFinishOnboarding: didFinishOnboarding ?? this.didFinishOnboarding,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  static const _key = 'ules.session.v1';

  @override
  SessionState build() {
    final repo = ref.read(repositoryProvider);
    unawaited(_restore());
    return SessionState(
      settings: const AppSettings(locale: Locale('ru'), themeMode: ThemeMode.dark),
      profile: repo.user,
      esim: repo.esim,
      participants: {for (final p in repo.products) p.id: p.currentParticipants},
      orders: const [],
      didFinishOnboarding: false,
      isLoaded: false,
    );
  }

  void setLocale(Locale locale) {
    state = state.copyWith(settings: state.settings.copyWith(locale: locale));
    _persist();
  }

  void toggleTheme(bool dark) {
    state = state.copyWith(settings: state.settings.copyWith(themeMode: dark ? ThemeMode.dark : ThemeMode.light));
    _persist();
  }

  void finishOnboarding() {
    state = state.copyWith(didFinishOnboarding: true);
    _persist();
  }

  void updateProfile(UserProfile profile) {
    ref.read(repositoryProvider).user = profile;
    state = state.copyWith(profile: profile);
    _persist();
  }

  void toggleInterest(ProductCategory category) {
    final next = {...state.profile.interests};
    next.contains(category) ? next.remove(category) : next.add(category);
    updateProfile(state.profile.copyWith(interests: next));
  }

  int participantsFor(String productId) {
    final product = ref.read(repositoryProvider).products.firstWhere((p) => p.id == productId);
    return state.participants[productId] ?? product.currentParticipants;
  }

  Product hydratedProduct(String id) {
    final product = ref.read(repositoryProvider).products.firstWhere((p) => p.id == id);
    return product.copyWith(currentParticipants: participantsFor(id));
  }

  List<RecommendedProduct> recommendations() {
    final repo = ref.read(repositoryProvider)..user = state.profile;
    final items = repo.products.map((product) {
      final hydrated = product.copyWith(currentParticipants: participantsFor(product.id));
      return RecommendedProduct(product: hydrated, score: repo.score(hydrated));
    }).toList();
    items.sort((a, b) => b.score.total.compareTo(a.score.total));
    return items;
  }

  void advanceGroup(String productId) {
    final product = hydratedProduct(productId);
    final current = participantsFor(productId);
    if (current >= product.minParticipants) return;
    final nextCount = current + 1;
    final participants = {...state.participants, productId: nextCount};
    final orders = state.orders.map((order) {
      if (order.productId != productId) return order;
      final nextStatus = nextCount >= product.minParticipants ? OrderStatus.groupClosed : order.status;
      return order.copyWith(
        participantsAtJoin: nextCount,
        finalPrice: product.priceForParticipants(nextCount),
        status: nextStatus,
      );
    }).toList();
    state = state.copyWith(participants: participants, orders: orders);
    _persist();
  }

  GroupOrder joinGroup(String productId) {
    final product = hydratedProduct(productId);
    final existing = state.orders.where((order) => order.productId == productId);
    if (existing.isNotEmpty) return existing.first;

    final nextCount = (participantsFor(productId) + 1).clamp(0, product.minParticipants).toInt();
    final finalPrice = product.priceForParticipants(nextCount);
    final order = GroupOrder(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      productTitle: product.title,
      imageUrl: product.imageUrl,
      heldAmount: product.retailPrice,
      finalPrice: finalPrice,
      participantsAtJoin: nextCount,
      targetParticipants: product.minParticipants,
      status: nextCount >= product.minParticipants ? OrderStatus.groupClosed : OrderStatus.paymentHeld,
      createdAt: DateTime.now(),
      esimId: state.esim.simId,
    );

    state = state.copyWith(
      participants: {...state.participants, productId: nextCount},
      orders: [order, ...state.orders],
    );
    _persist();
    return order;
  }

  void progressOrder(String orderId) {
    state = state.copyWith(
      orders: state.orders.map((order) {
        if (order.id != orderId) return order;
        final nextIndex = (order.status.index + 1).clamp(0, OrderStatus.values.length - 1).toInt();
        return order.copyWith(status: OrderStatus.values[nextIndex]);
      }).toList(),
    );
    _persist();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      state = state.copyWith(isLoaded: true);
      return;
    }
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      final repo = ref.read(repositoryProvider);
      final profile = _profileFromJson(Map<String, Object?>.from(json['profile'] as Map? ?? const {}));
      repo.user = profile;
      state = state.copyWith(
        settings: AppSettings(
          locale: Locale(json['locale'] as String? ?? 'ru'),
          themeMode: (json['themeMode'] as String?) == 'light' ? ThemeMode.light : ThemeMode.dark,
        ),
        profile: profile,
        esim: _esimFromJson(Map<String, Object?>.from(json['esim'] as Map? ?? const {})),
        participants: Map<String, int>.from(json['participants'] as Map? ?? const {}),
        orders: ((json['orders'] as List?) ?? const [])
            .map((item) => GroupOrder.fromJson(Map<String, Object?>.from(item as Map)))
            .toList(),
        didFinishOnboarding: json['didFinishOnboarding'] as bool? ?? false,
        isLoaded: true,
      );
    } catch (_) {
      state = state.copyWith(isLoaded: true);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_toJson(state)));
  }

  Map<String, Object?> _toJson(SessionState state) => {
        'locale': state.settings.locale.languageCode,
        'themeMode': state.settings.themeMode == ThemeMode.light ? 'light' : 'dark',
        'didFinishOnboarding': state.didFinishOnboarding,
        'profile': {
          'name': state.profile.name,
          'age': state.profile.age,
          'gender': state.profile.gender,
          'city': state.profile.city,
          'budget': state.profile.budget,
          'interests': state.profile.interests.map((item) => item.name).toList(),
        },
        'esim': {
          'operatorName': state.esim.operatorName,
          'simId': state.esim.simId,
          'isVerified': state.esim.isVerified,
          'deviceBoundAt': state.esim.deviceBoundAt.toIso8601String(),
        },
        'participants': state.participants,
        'orders': state.orders.map((order) => order.toJson()).toList(),
      };

  UserProfile _profileFromJson(Map<String, Object?> json) {
    final interests = ((json['interests'] as List?) ?? const [])
        .map((item) => ProductCategory.values.firstWhere((category) => category.name == item, orElse: () => ProductCategory.electronics))
        .toSet();
    return UserProfile(
      name: json['name'] as String? ?? 'Айдана',
      age: json['age'] as int? ?? 27,
      gender: json['gender'] as String? ?? 'Женщина',
      city: json['city'] as String? ?? 'Алматы',
      budget: json['budget'] as int? ?? 180000,
      interests: interests.isEmpty ? {ProductCategory.electronics, ProductCategory.home} : interests,
    );
  }

  EsimProfile _esimFromJson(Map<String, Object?> json) {
    return EsimProfile(
      operatorName: json['operatorName'] as String? ?? 'Beeline KZ',
      simId: json['simId'] as String? ?? 'ULES-48F2-9KZ7',
      isVerified: json['isVerified'] as bool? ?? true,
      deviceBoundAt: DateTime.tryParse(json['deviceBoundAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);

final settingsProvider = Provider<AppSettings>((ref) => ref.watch(sessionProvider).settings);
final profileProvider = Provider<UserProfile>((ref) => ref.watch(sessionProvider).profile);
final esimProvider = Provider<EsimProfile>((ref) => ref.watch(sessionProvider).esim);
final ordersProvider = Provider<List<GroupOrder>>((ref) => ref.watch(sessionProvider).orders);

final recommendationsProvider = Provider<List<RecommendedProduct>>((ref) {
  ref.watch(sessionProvider);
  return ref.read(sessionProvider.notifier).recommendations();
});

final productProvider = Provider.family<Product, String>((ref, id) {
  ref.watch(sessionProvider);
  return ref.read(sessionProvider.notifier).hydratedProduct(id);
});

final recommendationProvider = Provider.family<RecommendedProduct, String>((ref, id) {
  return ref.watch(recommendationsProvider).firstWhere((p) => p.product.id == id);
});

final participantStreamProvider = StreamProvider.family<int, String>((ref, id) {
  final session = ref.read(sessionProvider.notifier);
  return (() async* {
    var current = session.participantsFor(id);
    yield current;
    while (current < session.hydratedProduct(id).minParticipants) {
      await Future<void>.delayed(const Duration(seconds: 4));
      session.advanceGroup(id);
      current = session.participantsFor(id);
      yield current;
    }
  })();
});
