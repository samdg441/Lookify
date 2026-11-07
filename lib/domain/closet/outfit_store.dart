import '../models/outfit.dart';

abstract interface class OutfitStore {
  Future<List<Outfit>> getOutfits({String? occasion});

  Future<Outfit> getOutfit(String id);

  Future<Outfit> createOutfit({
    required String name,
    required List<String> garmentIds,
    String? occasion,
    String? season,
    String? notes,
  });

  Future<void> deleteOutfit(String id);

  Future<void> incrementWearCount(String id);
}
