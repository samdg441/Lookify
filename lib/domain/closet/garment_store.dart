import '../imaging/local_photo.dart';
import '../models/garment.dart';
import 'wardrobe_insights.dart';

abstract interface class GarmentStore {
  Future<List<Garment>> getGarments({String? category});

  Future<Garment> getGarment(String id);

  Future<Garment> createGarment({
    required String name,
    required String category,
    String? brand,
    String? color,
    String? season,
    String? occasion,
    double? price,
    String currency = Garment.defaultCurrency,
    String? notes,
    List<LocalPhoto> photos = const [],
  });

  Future<void> updateGarment({
    required String id,
    required String name,
    required String category,
    String? brand,
    String? color,
    String? season,
    String? occasion,
    double? price,
    String currency = Garment.defaultCurrency,
    String? notes,
    List<String>? keptImagePaths,
    List<LocalPhoto> photos = const [],
  });

  Future<void> deleteGarment(String id);

  Future<void> incrementWearCount(String id);

  /// Category counts and wear rankings from a single wardrobe read.
  Future<WardrobeInsights> insights({int limit = 5});
}
