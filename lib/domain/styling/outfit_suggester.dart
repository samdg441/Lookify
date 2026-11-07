import '../models/garment.dart';
import 'outfit_suggestion.dart';

abstract interface class OutfitSuggester {
  Future<List<OutfitSuggestion>> suggestOutfits({
    required List<Garment> garments,
    String? occasion,
    String? season,
    String? weather,
    int count = 3,
  });
}
