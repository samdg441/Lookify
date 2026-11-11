import '../auth/auth_gateway.dart';
import 'calendar_store.dart';
import 'garment_store.dart';
import 'outfit_store.dart';

/// Removes closet data, then the auth user. Reauthentication happens first
/// so a wrong password does not delete the wardrobe.
class CloseAccount {
  const CloseAccount({
    required this.auth,
    required this.garments,
    required this.outfits,
    required this.calendar,
  });

  final AuthGateway auth;
  final GarmentStore garments;
  final OutfitStore outfits;
  final CalendarStore calendar;

  Future<void> call({required String password}) async {
    await auth.reauthenticate(password: password);

    final wardrobe = await garments.getGarments();
    for (final garment in wardrobe) {
      await outfits.detachGarment(garment.id);
      await garments.deleteGarment(garment.id);
    }

    final remaining = await outfits.getOutfits();
    for (final outfit in remaining) {
      await outfits.deleteOutfit(outfit.id);
    }
    await calendar.deleteAll();
    await auth.deleteAccount();
  }
}
