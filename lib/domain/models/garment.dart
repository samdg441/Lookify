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
    this.currency = defaultCurrency,
    this.imageUrls = const [],
    this.notes,
    this.wearCount = 0,
    this.lastWorn,
    required this.createdAt,
  });

  static const defaultCurrency = 'COP';

  String? get coverImageUrl => imageUrls.isEmpty ? null : imageUrls.first;

  double get costPerWear {
    if (price == null || price! <= 0 || wearCount <= 0) return price ?? 0;
    return price! / wearCount;
  }
}
