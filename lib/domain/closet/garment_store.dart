import 'dart:io';

import '../../core/constants/app_constants.dart';
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
    String currency = AppConstants.defaultCurrency,
    String? notes,
    List<File> imageFiles = const [],
  });

  Future<void> deleteGarment(String id);

  Future<void> incrementWearCount(String id);

  /// Category counts and wear rankings from a single wardrobe read.
  Future<WardrobeInsights> insights({int limit = 5});
}
