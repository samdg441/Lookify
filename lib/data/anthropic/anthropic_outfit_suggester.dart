import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/models/garment.dart';
import '../../domain/styling/outfit_suggestion.dart';
import '../../domain/styling/outfit_suggester.dart';

class AnthropicOutfitSuggester implements OutfitSuggester {
  AnthropicOutfitSuggester(String apiKey, this._model)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.anthropic.com/v1',
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ));

  final String _model;
  final Dio _dio;

  @override
  Future<List<OutfitSuggestion>> suggestOutfits({
    required List<Garment> garments,
    String? occasion,
    String? season,
    String? weather,
    int count = 3,
  }) async {
    final garmentList = garments
        .map(
          (garment) => {
            'id': garment.id,
            'name': garment.name,
            'category': garment.category,
            'color': garment.color ?? 'unknown',
            'brand': garment.brand,
            'season': garment.season,
          },
        )
        .toList();

    final prompt = '''
You are a professional fashion stylist. Given this wardrobe:
${jsonEncode(garmentList)}

Create $count outfit suggestions${occasion != null ? ' for $occasion' : ''}${season != null ? ' suitable for $season' : ''}${weather != null ? ' with $weather weather' : ''}.

Respond ONLY with a JSON array, no other text. Each garments entry must be the garment id from the list above:
[
  {
    "name": "outfit name",
    "garments": ["garment id"],
    "description": "brief style description",
    "occasion": "occasion label",
    "tip": "one styling tip"
  }
]
''';

    final response = await _dio.post('/messages', data: {
      'model': _model,
      'max_tokens': 1024,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
    });

    final content = response.data['content'][0]['text'] as String;
    final decoded = _decodeArray(content);
    if (decoded == null) return [];

    return decoded.map((item) {
      final json = item as Map<String, dynamic>;
      final tokens = List<String>.from(json['garments'] ?? const []);
      return OutfitSuggestion(
        name: json['name'] as String? ?? 'Outfit',
        garments: matchSuggestedGarments(tokens, garments),
        description: json['description'] as String? ?? '',
        occasion: json['occasion'] as String? ?? 'Casual',
        tip: json['tip'] as String? ?? '',
      );
    }).toList();
  }

  List<dynamic>? _decodeArray(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is List) return decoded;
    } catch (_) {}

    final start = content.indexOf('[');
    final end = content.lastIndexOf(']');
    if (start < 0 || end <= start) return null;
    try {
      final decoded = jsonDecode(content.substring(start, end + 1));
      if (decoded is List) return decoded;
    } catch (_) {}
    return null;
  }
}
