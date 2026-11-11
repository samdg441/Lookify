enum OutfitMembershipChange { update, delete }

class OutfitMembershipPlan {
  const OutfitMembershipPlan({
    required this.outfitId,
    required this.change,
    this.garmentIds = const [],
  });

  final String outfitId;
  final OutfitMembershipChange change;
  final List<String> garmentIds;
}

/// Drops [garmentId] from every outfit that contains it. An outfit with no
/// garments left is deleted; the rest keep the remaining ids, in order.
List<OutfitMembershipPlan> planGarmentRemoval({
  required List<({String id, List<String> garmentIds})> outfits,
  required String garmentId,
}) {
  final plans = <OutfitMembershipPlan>[];
  for (final outfit in outfits) {
    if (!outfit.garmentIds.contains(garmentId)) continue;
    final remaining = [
      for (final id in outfit.garmentIds)
        if (id != garmentId) id,
    ];
    if (remaining.isEmpty) {
      plans.add(
        OutfitMembershipPlan(
          outfitId: outfit.id,
          change: OutfitMembershipChange.delete,
        ),
      );
    } else {
      plans.add(
        OutfitMembershipPlan(
          outfitId: outfit.id,
          change: OutfitMembershipChange.update,
          garmentIds: remaining,
        ),
      );
    }
  }
  return plans;
}
