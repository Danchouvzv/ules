import 'dart:async';
import 'dart:math';

import '../models/product.dart';

class MockRepository {
  final _random = Random(8);

  UserProfile user = const UserProfile(
    name: 'Айдана',
    age: 27,
    gender: 'Женщина',
    city: 'Алматы',
    budget: 180000,
    interests: {ProductCategory.electronics, ProductCategory.home, ProductCategory.beauty},
  );

  EsimProfile esim = EsimProfile(
    operatorName: 'Beeline KZ',
    simId: 'ULES-48F2-9KZ7',
    isVerified: true,
    deviceBoundAt: DateTime.now(),
  );

  late final List<Product> products = _seedProducts();

  List<RecommendedProduct> recommendations() {
    final scored = products.map((p) => RecommendedProduct(product: p, score: score(p))).toList();
    scored.sort((a, b) => b.score.total.compareTo(a.score.total));
    return scored;
  }

  RecommendationScore score(Product product) {
    final interestMatch = user.interests.contains(product.category) ? 1.0 : .28;
    final budgetFit = product.wholesalePrice <= user.budget
        ? 1.0
        : (user.budget / product.wholesalePrice).clamp(0.0, 1.0);
    final cityPopularity = product.cityPopularity[user.city] ?? .45;
    final groupCloseness = product.groupCloseness;
    final total = .36 * interestMatch + .22 * budgetFit + .22 * cityPopularity + .20 * groupCloseness;
    final reason = _reason(interestMatch, budgetFit, cityPopularity, groupCloseness, product);
    return RecommendationScore(
      total: total,
      interestMatch: interestMatch,
      budgetFit: budgetFit,
      cityPopularity: cityPopularity,
      groupCloseness: groupCloseness,
      reason: reason,
    );
  }

  Stream<int> participantStream(Product product) async* {
    var current = product.currentParticipants;
    yield current;
    while (current < product.minParticipants) {
      await Future<void>.delayed(Duration(seconds: 3 + _random.nextInt(3)));
      current++;
      yield current;
    }
  }

  String _reason(double interest, double budget, double city, double closeness, Product product) {
    if (closeness >= .8) return 'Группа закрывается через ${product.minParticipants - product.currentParticipants} человека';
    if (city >= .85) return 'Топ в ${user.city} по этой категории';
    if (budget >= .98) return 'Подходит под твой бюджет';
    if (interest >= .9) return 'Совпадает с твоим интересом';
    return 'Хороший баланс цены и спроса';
  }

  List<Product> _seedProducts() {
    const cities = ['Алматы', 'Астана', 'Шымкент', 'Караганда'];
    final data = [
      ('p1', 'Беспроводные наушники SoundPulse Pro', ProductCategory.electronics, Marketplace.aliexpress, 42000, 26900, 8, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=900'),
      ('p2', 'Умная LED-лента HomeGlow 10 м', ProductCategory.home, Marketplace.temu, 18000, 9200, 7, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=900'),
      ('p3', 'Мини-проектор PocketCinema 4K', ProductCategory.electronics, Marketplace.amazon, 145000, 99000, 6, 'https://images.unsplash.com/photo-1520383479841-f2ba5d4a9e6e?w=900'),
      ('p4', 'Корейский набор ухода Glass Skin', ProductCategory.beauty, Marketplace.temu, 36000, 21900, 9, 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=900'),
      ('p5', 'Складной велосипед CityFold', ProductCategory.sport, Marketplace.aliexpress, 210000, 154000, 5, 'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?w=900'),
      ('p6', 'Детский STEM-конструктор RobotLab', ProductCategory.kids, Marketplace.amazon, 65000, 41900, 7, 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=900'),
      ('p7', 'Автопылесос TurboClean', ProductCategory.auto, Marketplace.aliexpress, 39000, 24500, 8, 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=900'),
      ('p8', 'Oversize пуховик Nordic Shell', ProductCategory.fashion, Marketplace.temu, 78000, 51000, 4, 'https://images.unsplash.com/photo-1548883354-94bcfe321cbb?w=900'),
      ('p9', 'Power Bank MagSafe 20000 mAh', ProductCategory.electronics, Marketplace.aliexpress, 31000, 18500, 9, 'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=900'),
      ('p10', 'Набор вакуумных контейнеров FreshBox', ProductCategory.home, Marketplace.amazon, 28000, 16900, 6, 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=900'),
      ('p11', 'Йога-мат StudioGrip Pro', ProductCategory.sport, Marketplace.temu, 24000, 13900, 7, 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=900'),
      ('p12', 'Органайзер для багажника Nomad', ProductCategory.auto, Marketplace.amazon, 33000, 19900, 5, 'https://images.unsplash.com/photo-1549924231-f129b911e442?w=900'),
      ('p13', 'Паровой отпариватель SwiftSteam', ProductCategory.home, Marketplace.aliexpress, 46000, 28900, 8, 'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?w=900'),
      ('p14', 'Смарт-часы Pulse X', ProductCategory.electronics, Marketplace.temu, 89000, 57900, 7, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=900'),
      ('p15', 'Чемодан CabinLite 38L', ProductCategory.travel, Marketplace.amazon, 72000, 45900, 6, 'https://images.unsplash.com/photo-1553531384-cc64ac80f931?w=900'),
      ('p16', 'Массажер для шеи RelaxRing', ProductCategory.beauty, Marketplace.aliexpress, 52000, 32900, 8, 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=900'),
      ('p17', 'Капсульная кофемашина MiniBarista', ProductCategory.home, Marketplace.temu, 118000, 79000, 4, 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=900'),
      ('p18', 'Детское автокресло SafeRide', ProductCategory.kids, Marketplace.amazon, 132000, 93000, 6, 'https://images.unsplash.com/photo-1522771930-78848d9293e8?w=900'),
    ];

    return data.map((row) {
      final popularity = {
        for (final city in cities) city: (.45 + _random.nextDouble() * .5).clamp(0, 1).toDouble(),
      };
      popularity['Алматы'] = (.68 + _random.nextDouble() * .28).clamp(0, 1).toDouble();
      return Product(
        id: row.$1,
        title: row.$2,
        description: 'Проверенный товар для коллективной покупки с прозрачной экономией, локальной ценой в тенге и безопасным местом в группе.',
        category: row.$3,
        marketplace: row.$4,
        retailPrice: row.$5,
        wholesalePrice: row.$6,
        currentParticipants: row.$7,
        minParticipants: 10,
        imageUrl: row.$8,
        cityPopularity: popularity,
        specs: const ['Доставка в Казахстан', 'Гарантия маркетплейса', 'Проверенный продавец', 'Оплата Kaspi Pay'],
        seller: '${row.$4.label} Choice Store',
        rating: 4.6 + _random.nextDouble() * .35,
      );
    }).toList();
  }
}
