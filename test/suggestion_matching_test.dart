import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_closet/domain/models/garment.dart';
import 'package:virtual_closet/domain/styling/outfit_suggestion.dart';

void main() {
  final wardrobe = [
    Garment(
      id: 'red-1',
      userId: 'u',
      name: 'Red shirt',
      category: 'Tops',
      createdAt: DateTime.utc(2026, 1, 1),
    ),
    Garment(
      id: 'red-2',
      userId: 'u',
      name: 'Red scarf',
      category: 'Accessories',
      createdAt: DateTime.utc(2026, 1, 2),
    ),
  ];

  test('matches a garment id exactly', () {
    final matched = matchSuggestedGarments(['red-2'], wardrobe);
    expect(matched.map((garment) => garment.id), ['red-2']);
  });

  test('matches an exact name and ignores a shared word', () {
    final matched = matchSuggestedGarments(['Red'], wardrobe);
    expect(matched, isEmpty);

    final named = matchSuggestedGarments(['red shirt'], wardrobe);
    expect(named.map((garment) => garment.id), ['red-1']);
  });

  test('suggestion requests with the same filters are equal', () {
    const first = SuggestionRequest(occasion: 'Work', season: 'Fall');
    const second = SuggestionRequest(occasion: 'Work', season: 'Fall');
    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}
