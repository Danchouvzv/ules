enum Marketplace { aliexpress, amazon, temu }

enum ProductCategory {
  electronics,
  home,
  beauty,
  sport,
  kids,
  auto,
  fashion,
  travel,
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.marketplace,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.currentParticipants,
    required this.minParticipants,
    required this.cityPopularity,
    required this.specs,
    required this.seller,
    required this.rating,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final ProductCategory category;
  final Marketplace marketplace;
  final int retailPrice;
  final int wholesalePrice;
  final int currentParticipants;
  final int minParticipants;
  final Map<String, double> cityPopularity;
  final List<String> specs;
  final String seller;
  final double rating;

  double get groupCloseness => (currentParticipants / minParticipants).clamp(0, 1).toDouble();

  int priceForParticipants(int participants) {
    final progress = (participants / minParticipants).clamp(0, 1);
    final eased = 1 - (1 - progress) * (1 - progress);
    return (retailPrice - ((retailPrice - wholesalePrice) * eased)).round();
  }

  Product copyWith({int? currentParticipants}) {
    return Product(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      category: category,
      marketplace: marketplace,
      retailPrice: retailPrice,
      wholesalePrice: wholesalePrice,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      minParticipants: minParticipants,
      cityPopularity: cityPopularity,
      specs: specs,
      seller: seller,
      rating: rating,
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.city,
    required this.budget,
    required this.interests,
  });

  final String name;
  final int age;
  final String gender;
  final String city;
  final int budget;
  final Set<ProductCategory> interests;

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    String? city,
    int? budget,
    Set<ProductCategory>? interests,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      budget: budget ?? this.budget,
      interests: interests ?? this.interests,
    );
  }
}

class EsimProfile {
  const EsimProfile({
    required this.operatorName,
    required this.simId,
    required this.isVerified,
    required this.deviceBoundAt,
  });

  final String operatorName;
  final String simId;
  final bool isVerified;
  final DateTime deviceBoundAt;
}

enum OrderStatus {
  paymentHeld,
  collecting,
  groupClosed,
  sellerOrdered,
  delivery,
}

class GroupOrder {
  const GroupOrder({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.imageUrl,
    required this.heldAmount,
    required this.finalPrice,
    required this.participantsAtJoin,
    required this.targetParticipants,
    required this.status,
    required this.createdAt,
    required this.esimId,
  });

  final String id;
  final String productId;
  final String productTitle;
  final String imageUrl;
  final int heldAmount;
  final int finalPrice;
  final int participantsAtJoin;
  final int targetParticipants;
  final OrderStatus status;
  final DateTime createdAt;
  final String esimId;

  bool get isGroupClosed => participantsAtJoin >= targetParticipants || status.index >= OrderStatus.groupClosed.index;

  GroupOrder copyWith({
    int? finalPrice,
    int? participantsAtJoin,
    OrderStatus? status,
  }) {
    return GroupOrder(
      id: id,
      productId: productId,
      productTitle: productTitle,
      imageUrl: imageUrl,
      heldAmount: heldAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      participantsAtJoin: participantsAtJoin ?? this.participantsAtJoin,
      targetParticipants: targetParticipants,
      status: status ?? this.status,
      createdAt: createdAt,
      esimId: esimId,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'productId': productId,
        'productTitle': productTitle,
        'imageUrl': imageUrl,
        'heldAmount': heldAmount,
        'finalPrice': finalPrice,
        'participantsAtJoin': participantsAtJoin,
        'targetParticipants': targetParticipants,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'esimId': esimId,
      };

  static GroupOrder fromJson(Map<String, Object?> json) {
    return GroupOrder(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      imageUrl: json['imageUrl'] as String,
      heldAmount: json['heldAmount'] as int,
      finalPrice: json['finalPrice'] as int,
      participantsAtJoin: json['participantsAtJoin'] as int,
      targetParticipants: json['targetParticipants'] as int,
      status: OrderStatus.values.firstWhere((s) => s.name == json['status'], orElse: () => OrderStatus.paymentHeld),
      createdAt: DateTime.parse(json['createdAt'] as String),
      esimId: json['esimId'] as String,
    );
  }
}

class RecommendationScore {
  const RecommendationScore({
    required this.total,
    required this.interestMatch,
    required this.budgetFit,
    required this.cityPopularity,
    required this.groupCloseness,
    required this.reason,
  });

  final double total;
  final double interestMatch;
  final double budgetFit;
  final double cityPopularity;
  final double groupCloseness;
  final String reason;
}

class RecommendedProduct {
  const RecommendedProduct({required this.product, required this.score});
  final Product product;
  final RecommendationScore score;
}

extension ProductLabels on ProductCategory {
  String label(String lang) {
    final kk = lang == 'kk';
    return switch (this) {
      ProductCategory.electronics => kk ? 'Электроника' : 'Электроника',
      ProductCategory.home => kk ? 'Үй' : 'Дом и быт',
      ProductCategory.beauty => kk ? 'Сұлулық' : 'Красота',
      ProductCategory.sport => kk ? 'Спорт' : 'Спорт',
      ProductCategory.kids => kk ? 'Балалар' : 'Детские товары',
      ProductCategory.auto => kk ? 'Авто' : 'Авто',
      ProductCategory.fashion => kk ? 'Сән' : 'Мода',
      ProductCategory.travel => kk ? 'Саяхат' : 'Путешествия',
    };
  }
}

extension MarketplaceLabels on Marketplace {
  String get label => switch (this) {
        Marketplace.aliexpress => 'AliExpress',
        Marketplace.amazon => 'Amazon',
        Marketplace.temu => 'Temu',
      };
}
