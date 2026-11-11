import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_closet/domain/closet/garment_query.dart';
import 'package:virtual_closet/domain/closet/outfit_membership.dart';
import 'package:virtual_closet/domain/closet/wardrobe_insights.dart';
import 'package:virtual_closet/domain/closet/wear_log.dart';
import 'package:virtual_closet/domain/models/garment.dart';
import 'package:virtual_closet/domain/styling/outfit_suggestion.dart';

Garment garment({
  required String id,
  required String name,
  String category = 'Tops',
  String? brand,
  String? color,
  double? price,
  int wearCount = 0,
}) {
  return Garment(
    id: id,
    userId: 'u',
    name: name,
    category: category,
    brand: brand,
    color: color,
    price: price,
    wearCount: wearCount,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  test('search matches name, brand, and color, and ignores blank queries', () {
    final shirt = garment(id: '1', name: 'Linen shirt', brand: 'Zara', color: 'Blue');
    expect(garmentMatchesQuery(shirt, '   '), isTrue);
    expect(garmentMatchesQuery(shirt, 'linen'), isTrue);
    expect(garmentMatchesQuery(shirt, 'zara'), isTrue);
    expect(garmentMatchesQuery(shirt, 'blue'), isTrue);
    expect(garmentMatchesQuery(shirt, 'wool'), isFalse);
  });

  test('wearing an outfit counts only the first time it is planned today', () {
    final today = DateTime(2026, 11, 11, 18);
    expect(
      shouldLogWear(
        date: DateTime(2026, 11, 11),
        now: today,
        outfitId: 'a',
        previousOutfitId: null,
      ),
      isTrue,
    );
    expect(
      shouldLogWear(
        date: DateTime(2026, 11, 11),
        now: today,
        outfitId: 'a',
        previousOutfitId: 'a',
      ),
      isFalse,
    );
    expect(
      shouldLogWear(
        date: DateTime(2026, 11, 12),
        now: today,
        outfitId: 'a',
      ),
      isFalse,
    );
  });

  test('removing a garment deletes an empty outfit and keeps the rest', () {
    final plans = planGarmentRemoval(
      outfits: [
        (id: 'solo', garmentIds: ['shirt']),
        (id: 'pair', garmentIds: ['shirt', 'pants']),
        (id: 'other', garmentIds: ['coat']),
      ],
      garmentId: 'shirt',
    );
    expect(plans, hasLength(2));
    expect(plans.first.change, OutfitMembershipChange.delete);
    expect(plans.last.change, OutfitMembershipChange.update);
    expect(plans.last.garmentIds, ['pants']);
  });

  test('wardrobe summary averages cost per wear of worn priced items', () {
    final insights = summarizeWardrobe([
      garment(id: '1', name: 'A', price: 100, wearCount: 4),
      garment(id: '2', name: 'B', price: 50, wearCount: 0),
      garment(id: '3', name: 'C', category: 'Shoes', price: 80, wearCount: 2),
    ]);
    expect(insights.total, 3);
    expect(insights.categoryCounts['Tops'], 2);
    expect(insights.averageCostPerWear, 32.5);
    expect(insights.mostWorn.first.id, '1');
  });

  test('suggestion payloads keep only garments that exist in the wardrobe', () {
    final wardrobe = [garment(id: 'shirt', name: 'Shirt')];
    final suggestions = suggestionsFromMaps([
      {
        'name': 'Office',
        'garments': ['shirt', 'missing'],
        'description': 'Clean',
        'occasion': 'Work',
        'tip': 'Tuck it in',
      },
    ], wardrobe);
    expect(suggestions.single.garments.map((item) => item.id), ['shirt']);
    expect(suggestions.single.occasion, 'Work');
  });

  test('weather changes the suggestion cache key', () {
    const hot = SuggestionRequest(occasion: 'Casual', weather: 'Hot');
    const cold = SuggestionRequest(occasion: 'Casual', weather: 'Cold');
    expect(hot, isNot(cold));
  });
}
