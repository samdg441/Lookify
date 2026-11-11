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

### 2. Outfit suggestions

Suggestions are requested from the Cloud Function `suggestOutfits`. The app does not ship an API key. Set these Firebase secrets before deploying functions:

```bash
firebase functions:secrets:set ANTHROPIC_API_KEY
firebase functions:secrets:set ANTHROPIC_MODEL
firebase deploy --only functions,firestore:rules,storage
```

`ANTHROPIC_MODEL` is the model id. A small, fast model is enough.

### 3. Firebase

The Android and web apps are already registered on the Firebase project `lookify-closet`. `lib/firebase_options.dart` and `android/app/google-services.json` point at that project.

1. In Firebase Console, enable Email/Password under Authentication.
2. Deploy `firestore.rules`. They allow a signed-in user to read and write only `users/{their uid}/**`.
Closet data is stored per user:

- `users/{uid}/garments`
- `users/{uid}/outfits`
- `users/{uid}/calendar`

Another database can replace Firebase by implementing `AuthGateway`, `GarmentStore`, `OutfitStore`, and `CalendarStore`, then changing the providers in `lib/presentation/providers/providers.dart`. Screens do not import Firebase.

### 4. Install dependencies & run

```bash
flutter pub get
flutter run
```

### 5. (Optional) Add Playfair Display fonts

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
│   ├── firebase/    # Auth, Firestore, Storage, and outfit suggestions
│   ├── datasources/ # On-device background removal
│   ├── diagnostics/ # Crashlytics adapter and web/desktop no-op
│   └── firebase/    # Auth, Firestore, Storage, and outfit suggestions
├── core/            # Theme, constants, and shared helpers
├── presentation/
│   ├── providers/   # Composition root: ports wired to Firebase
│   ├── screens/
│   └── widgets/
├── app.dart         # GoRouter + MaterialApp
└── main.dart        # Firebase init, Crashlytics, ProviderScope
```

## AI Outfit Suggestions

The AI tab in Outfits calls `suggestOutfits`. The function uses the wardrobe and the occasion, season, and weather filters, then returns an outfit name, the garments from the closet, a styling tip, and an occasion. The same filters are reused while the wardrobe stays the same. Changing those filters requests a new set. Each suggestion can be saved directly as an outfit.

## Building for release

See [README.md](README.md#building-the-app) for build commands across all platforms (Android, iOS, desktop, web).
