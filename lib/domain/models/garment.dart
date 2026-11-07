import '../../core/constants/app_constants.dart';

class Garment {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String? brand;
  final String? color;
  final String? season;
  final String? occasion;
  final double? price;
  final String currency;
  final List<String> imageUrls;
  final String? notes;
  final int wearCount;
  final DateTime? lastWorn;
  final DateTime createdAt;

  const Garment({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    this.brand,
    this.color,
    this.season,
    this.occasion,
    this.price,
    this.currency = AppConstants.defaultCurrency,
    this.imageUrls = const [],
    this.notes,
    this.wearCount = 0,
    this.lastWorn,
    required this.createdAt,
  });

  String? get coverImageUrl => imageUrls.isEmpty ? null : imageUrls.first;

  double get costPerWear {
    if (price == null || price! <= 0 || wearCount <= 0) return price ?? 0;
    return price! / wearCount;
  }

  Garment copyWith({
    String? name,
    String? category,
    String? brand,
    String? color,
    String? season,
    String? occasion,
    double? price,
    String? currency,
    List<String>? imageUrls,
    String? notes,
    int? wearCount,
    DateTime? lastWorn,
  }) =>
      Garment(
        id: id,
        userId: userId,
        name: name ?? this.name,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        color: color ?? this.color,
        season: season ?? this.season,
        occasion: occasion ?? this.occasion,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        imageUrls: imageUrls ?? this.imageUrls,
        notes: notes ?? this.notes,
        wearCount: wearCount ?? this.wearCount,
        lastWorn: lastWorn ?? this.lastWorn,
        createdAt: createdAt,
      );
}
