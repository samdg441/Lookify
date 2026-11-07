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
  const SuggestionRequest({this.occasion, this.season});

  final String? occasion;
  final String? season;

  @override
  bool operator ==(Object other) {
    return other is SuggestionRequest &&
        other.occasion == occasion &&
        other.season == season;
  }

  @override
  int get hashCode => Object.hash(occasion, season);
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
