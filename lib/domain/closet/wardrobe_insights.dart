import '../models/garment.dart';

/// One read of the wardrobe, already reduced for the analytics screen.
class WardrobeInsights {
  const WardrobeInsights({
    required this.total,
    required this.categoryCounts,
    required this.mostWorn,
    required this.leastWorn,
  });

  final int total;
  final Map<String, int> categoryCounts;
  final List<Garment> mostWorn;
  final List<Garment> leastWorn;
}
