const { onCall, HttpsError } = require('firebase-functions/v2/https');

const MAX_GARMENTS = 200;
const MAX_COUNT = 5;

exports.suggestOutfits = onCall(
  { secrets: ['ANTHROPIC_API_KEY'], timeoutSeconds: 60 },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign in required');
    }

    const apiKey = process.env.ANTHROPIC_API_KEY;
    const model = process.env.ANTHROPIC_MODEL;
    if (!apiKey || !model) {
      throw new HttpsError(
        'failed-precondition',
        'Outfit suggestions are not configured',
      );
    }

    const data = request.data ?? {};
    const garments = Array.isArray(data.garments) ? data.garments : [];
    if (garments.length === 0) return { suggestions: [] };
    if (garments.length > MAX_GARMENTS) {
      throw new HttpsError('invalid-argument', 'Too many garments');
    }

    const count = Math.min(
      MAX_COUNT,
      Math.max(1, Number(data.count) || 3),
    );
    const wardrobe = garments.slice(0, MAX_GARMENTS).map((garment) => ({
      id: String(garment.id ?? ''),
      name: String(garment.name ?? ''),
      category: String(garment.category ?? ''),
      color: garment.color ? String(garment.color) : 'unknown',
      brand: garment.brand ? String(garment.brand) : null,
      season: garment.season ? String(garment.season) : null,
    }));

    const filters = [
      data.occasion ? ` for ${data.occasion}` : '',
      data.season ? ` suitable for ${data.season}` : '',
      data.weather ? ` with ${data.weather} weather` : '',
    ].join('');

    const prompt = `You are a professional fashion stylist. Given this wardrobe:
${JSON.stringify(wardrobe)}

Create ${count} outfit suggestions${filters}.

Respond ONLY with a JSON array, no other text. Each garments entry must be the garment id from the list above:
[
  {
    "name": "outfit name",
    "garments": ["garment id"],
    "description": "brief style description",
    "occasion": "occasion label",
    "tip": "one styling tip"
  }
]`;

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        model,
        max_tokens: 1024,
        messages: [{ role: 'user', content: prompt }],
      }),
    });

    if (!response.ok) {
      throw new HttpsError('internal', 'The stylist could not respond');
    }

    const body = await response.json();
    const text = body?.content?.[0]?.text;
    if (typeof text !== 'string') return { suggestions: [] };
    return { suggestions: decodeArray(text) };
  },
);

function decodeArray(content) {
  try {
    const decoded = JSON.parse(content);
    if (Array.isArray(decoded)) return decoded;
  } catch (_) {
    // The model sometimes wraps the array in prose. Fall through.
  }
  const start = content.indexOf('[');
  const end = content.lastIndexOf(']');
  if (start < 0 || end <= start) return [];
  try {
    const decoded = JSON.parse(content.slice(start, end + 1));
    return Array.isArray(decoded) ? decoded : [];
  } catch (_) {
    return [];
  }
}
