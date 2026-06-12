import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = UlesLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);
    final products = ref.watch(recommendationsProvider);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 132,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 22, bottom: 18),
              title: Text(l.t('feedTitle'), style: const TextStyle(fontWeight: FontWeight.w900)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [UlesColors.primary.withOpacity(.42), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => ref.read(sessionProvider.notifier).setLocale(Locale(settings.locale.languageCode == 'ru' ? 'kk' : 'ru')),
                child: Text(settings.locale.languageCode.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
              IconButton(onPressed: () => context.go('/profile'), icon: Icon(PhosphorIcons.userCircle())),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${l.t('hello')} · ${profile.city}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ),
                  Icon(PhosphorIcons.mapPin(), color: UlesColors.green, size: 18),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  final category = ProductCategory.values[i];
                  final selected = profile.interests.contains(category);
                  return FilterChip(
                    selected: selected,
                    label: Text(category.label(lang)),
                    selectedColor: UlesColors.green,
                    onSelected: (_) => ref.read(sessionProvider.notifier).toggleInterest(category),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: ProductCategory.values.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            sliver: SliverList.builder(
              itemCount: products.length,
              itemBuilder: (context, i) => ProductCard(item: products[i]),
            ),
          ),
        ],
      ),
    );
  }
}
