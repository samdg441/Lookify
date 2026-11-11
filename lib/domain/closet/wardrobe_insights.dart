import '../models/garment.dart';

/// One read of the wardrobe, already reduced for the analytics screen.
class WardrobeInsights {
  const WardrobeInsights({
    required this.total,
    required this.categoryCounts,
    required this.mostWorn,
    required this.leastWorn,
    this.averageCostPerWear,
  });

  final int total;
  final Map<String, int> categoryCounts;
  final List<Garment> mostWorn;
  final List<Garment> leastWorn;

  /// Mean cost-per-wear of priced garments that have been worn at least once.
  final double? averageCostPerWear;
}

WardrobeInsights summarizeWardrobe(List<Garment> garments, {int limit = 5}) {
  final counts = <String, int>{};
  for (final garment in garments) {
    counts[garment.category] = (counts[garment.category] ?? 0) + 1;
  }

  final byWear = [...garments]
    ..sort((a, b) => b.wearCount.compareTo(a.wearCount));
  final mostWorn = byWear.take(limit).toList();
  final mostWornIds = mostWorn.map((garment) => garment.id).toSet();

  final costs = [
    for (final garment in garments)
      if (garment.price != null && garment.price! > 0 && garment.wearCount > 0)
        garment.costPerWear,
  ];

  return WardrobeInsights(
    total: garments.length,
    categoryCounts: counts,
    mostWorn: mostWorn,
    leastWorn: byWear.reversed
        .where((garment) => !mostWornIds.contains(garment.id))
        .take(limit)
        .toList(),
    averageCostPerWear: costs.isEmpty
        ? null
        : costs.reduce((sum, cost) => sum + cost) / costs.length,
  );
}
