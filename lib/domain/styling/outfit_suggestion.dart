import '../models/garment.dart';

class OutfitSuggestion {
  final String name;
  final List<Garment> garments;
  final String description;
  final String occasion;
  final String tip;

  const OutfitSuggestion({
    required this.name,
    required this.garments,
    required this.description,
    required this.occasion,
    required this.tip,
  });
}

class SuggestionRequest {
  const SuggestionRequest({this.occasion, this.season, this.weather});

  final String? occasion;
  final String? season;
  final String? weather;

  @override
  bool operator ==(Object other) {
    return other is SuggestionRequest &&
        other.occasion == occasion &&
        other.season == season &&
        other.weather == weather;
  }

  @override
  int get hashCode => Object.hash(occasion, season, weather);
}

List<OutfitSuggestion> suggestionsFromMaps(
  List<dynamic> items,
  List<Garment> wardrobe,
) {
  final suggestions = <OutfitSuggestion>[];
  for (final item in items) {
    if (item is! Map) continue;
    final json = Map<String, dynamic>.from(item);
    final tokens = [
      for (final token in json['garments'] as List<dynamic>? ?? const [])
        token.toString(),
    ];
    suggestions.add(
      OutfitSuggestion(
        name: json['name'] as String? ?? 'Outfit',
        garments: matchSuggestedGarments(tokens, wardrobe),
        description: json['description'] as String? ?? '',
        occasion: json['occasion'] as String? ?? 'Casual',
        tip: json['tip'] as String? ?? '',
      ),
    );
  }
  return suggestions;
}

/// Prefer an exact id, then an exact name. Substring matching pairs the
/// wrong garments when names share a word.
List<Garment> matchSuggestedGarments(
  List<String> tokens,
  List<Garment> wardrobe,
) {
  final byId = {for (final garment in wardrobe) garment.id: garment};
  final byName = {
    for (final garment in wardrobe) garment.name.toLowerCase(): garment,
  };
  final matched = <Garment>[];
  final seen = <String>{};

  for (final token in tokens) {
    final garment = byId[token] ?? byName[token.toLowerCase()];
    if (garment != null && seen.add(garment.id)) {
      matched.add(garment);
    }
  }
  return matched;
}
