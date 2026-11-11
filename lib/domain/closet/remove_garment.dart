import 'garment_store.dart';
import 'outfit_store.dart';

class RemoveGarment {
  const RemoveGarment({
    required this.garments,
    required this.outfits,
  });

  final GarmentStore garments;
  final OutfitStore outfits;

  Future<void> call(String id) async {
    await outfits.detachGarment(id);
    await garments.deleteGarment(id);
  }
}
