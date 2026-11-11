import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/models/garment.dart';
import '../../domain/styling/outfit_suggestion.dart';
import '../../domain/styling/outfit_suggester.dart';

/// Asks the `suggestOutfits` Cloud Function for outfits. The model key stays
/// on the server; this client only sends garment metadata and filters.
class FirebaseOutfitSuggester implements OutfitSuggester {
  FirebaseOutfitSuggester({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  @override
  Future<List<OutfitSuggestion>> suggestOutfits({
    required List<Garment> garments,
    String? occasion,
    String? season,
    String? weather,
    int count = 3,
  }) async {
    final callable = _functions.httpsCallable('suggestOutfits');
    final response = await callable.call({
      'garments': [
        for (final garment in garments)
          {
            'id': garment.id,
            'name': garment.name,
            'category': garment.category,
            'color': garment.color,
            'brand': garment.brand,
            'season': garment.season,
          },
      ],
      'occasion': occasion,
      'season': season,
      'weather': weather,
      'count': count,
    });
    final data = response.data;
    if (data is! Map) return [];
    final raw = Map<String, dynamic>.from(data)['suggestions'];
    if (raw is! List) return [];
    return suggestionsFromMaps(raw, garments);
  }
}
