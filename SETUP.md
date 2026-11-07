# Virtual Closet — Mobile App

> Your closet, curated. — Flutter + Firebase

## Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod |
| Navigation | GoRouter |
| Backend | Firebase Auth, Cloud Firestore, and Storage, behind ports |
| Crash reports | Firebase Crashlytics on mobile, no-op elsewhere |
| AI Suggestions | Anthropic Messages API (model set via `AI_MODEL`) |
| Background Removal | ML Kit Subject Segmentation, on-device (Android only) |
| Charts | fl_chart |
| Calendar | table_calendar |

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Logo animation → Auth check |
| Login / Register | Firebase email/password auth |
| My Closet | Grid of garments, filter by category |
| Add Garment | Photo + metadata form, optional on-device background removal (Android, on by default) |
| Garment Detail | Stats, wear tracking, delete |
| My Outfits | Saved outfits + AI tab |
| AI Suggestions | AI generates outfits from wardrobe |
| Outfit Builder | Select garments → save outfit |
| Calendar | Assign outfits to days with table_calendar |
| Analytics | Pie chart by category, most/least worn |
| Profile | Account info, sign out |

## Setup

### 1. Prerequisites

```bash
# Install Flutter: https://docs.flutter.dev/get-started/install
flutter --version  # requires 3.19+
```

### 2. Configure environment

Create `.env` in the project root. The app loads it at startup, and outfit suggestions need both keys:

```dotenv
AI_API_KEY=sk-ant-...
AI_MODEL=<model-id>
```

### 3. Firebase

The Android and web apps are already registered on the Firebase project `lookify-closet`. `lib/firebase_options.dart` and `android/app/google-services.json` point at that project.

1. In Firebase Console, enable Email/Password under Authentication.
2. Deploy `firestore.rules`. They allow a signed-in user to read and write only `users/{their uid}/**`.
3. Storage rules should allow that same user to read and write `garments/{uid}/**`.

Closet data is stored per user:

- `users/{uid}/garments`
- `users/{uid}/outfits`
- `users/{uid}/calendar`

Another database can replace Firebase by implementing `AuthGateway`, `GarmentStore`, `OutfitStore`, and `CalendarStore`, then changing the providers in `lib/presentation/providers/providers.dart`. Screens do not import Firebase.

### 4. Get an AI API key

1. Go to https://console.anthropic.com
2. Create an API key
3. Add it to `.env` as `AI_API_KEY`
4. Set `AI_MODEL` in `.env` to the ID of the model you want to use (a small, fast model is enough for outfit suggestions)

### 5. Install dependencies & run

```bash
flutter pub get
flutter run
```

### 6. (Optional) Add Playfair Display fonts

Download from Google Fonts and place in `assets/fonts/`:
- `PlayfairDisplay-Regular.ttf`
- `PlayfairDisplay-Bold.ttf`
- `PlayfairDisplay-Italic.ttf`

Or remove the font declarations from `pubspec.yaml` to use the fallback.

## Project Structure

```
lib/
├── domain/
│   ├── auth/        # AuthGateway and session, no Firebase types
│   ├── closet/      # GarmentStore, OutfitStore, CalendarStore
│   ├── diagnostics/ # CrashReporter
│   ├── imaging/     # BackgroundRemover
│   ├── models/      # Garment, Outfit, CalendarEntry
│   └── styling/     # OutfitSuggester
├── data/
│   ├── anthropic/   # Outfit suggestion adapter
│   ├── datasources/ # On-device background removal
│   ├── diagnostics/ # Crashlytics adapter and web/desktop no-op
│   └── firebase/    # Auth, Firestore, and Storage adapters
├── core/            # Theme, constants, and shared helpers
├── presentation/
│   ├── providers/   # Composition root: ports wired to Firebase
│   ├── screens/
│   └── widgets/
├── app.dart         # GoRouter + MaterialApp
└── main.dart        # Firebase init, Crashlytics, ProviderScope
```

## AI Outfit Suggestions

The AI tab in Outfits uses the model configured in `AI_MODEL` to analyze your wardrobe and generate outfit suggestions with:
- Outfit name and description
- Specific garments from your closet
- Styling tip
- Occasion label

Suggestions for the same occasion, season, and weather are reused while the wardrobe stays the same. Changing those filters requests a new set. Each suggestion can be saved directly as an outfit.

## Building for release

See [README.md](README.md#building-the-app) for build commands across all platforms (Android, iOS, desktop, web).
