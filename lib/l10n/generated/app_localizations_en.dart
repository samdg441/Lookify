// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Virtual Closet';

  @override
  String get appTagline => 'Your closet, curated.';

  @override
  String get appMark => 'CLOSET';

  @override
  String get closet => 'Closet';

  @override
  String get outfits => 'Outfits';

  @override
  String get calendar => 'Calendar';

  @override
  String get analytics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get myCloset => 'My Closet';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get addGarment => 'Add Garment';

  @override
  String get editGarment => 'Edit Garment';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get clear => 'Clear';

  @override
  String get or => 'or';

  @override
  String get today => 'Today';

  @override
  String get all => 'All';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get searchHint => 'Search name, brand, color';

  @override
  String get searchFailed => 'Failed to search the wardrobe';

  @override
  String get nothingToSearch => 'Nothing to search yet';

  @override
  String get nothingToSearchSubtitle =>
      'Add a garment and search it by name, brand, or color';

  @override
  String get noMatches => 'No matches';

  @override
  String get noMatchesSubtitle => 'Try a different name, brand, or color';

  @override
  String get wardrobeFailed => 'Failed to load wardrobe';

  @override
  String get closetEmpty => 'Your closet is empty';

  @override
  String get closetEmptySubtitle =>
      'Add your first garment to start building your wardrobe';

  @override
  String categoryEmpty(String category) {
    return 'No $category yet';
  }

  @override
  String get categoryEmptySubtitle =>
      'Try a different category or add a new garment';

  @override
  String get garmentNotFound => 'Garment not found';

  @override
  String couldNotSaveGarment(String error) {
    return 'Could not save the garment: $error';
  }

  @override
  String get removingBackground => 'Removing background...';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get addPhotosHint => 'Tap to upload from camera or gallery';

  @override
  String get removeBackground => 'Remove background';

  @override
  String get removeBackgroundSubtitle => 'Applies on-device to new photos';

  @override
  String backgroundPreparing(int progress) {
    return 'Preparing background removal ($progress%). Try again in a moment';
  }

  @override
  String backgroundSkipped(int skipped, int total) {
    return 'Couldn\'t remove background for $skipped of $total photos';
  }

  @override
  String get nameRequired => 'Name *';

  @override
  String get enterGarmentName => 'Enter garment name';

  @override
  String get brand => 'Brand';

  @override
  String get price => 'Price';

  @override
  String get currency => 'Currency';

  @override
  String get categoryRequired => 'Category *';

  @override
  String get color => 'Color';

  @override
  String get season => 'Season';

  @override
  String get occasion => 'Occasion';

  @override
  String get weather => 'Weather';

  @override
  String get notes => 'Notes';

  @override
  String get timesWorn => 'Times worn';

  @override
  String get costPerWear => 'Cost / wear';

  @override
  String get lastWorn => 'Last worn';

  @override
  String get notAvailable => 'N/A';

  @override
  String get logWornToday => 'Log as Worn Today';

  @override
  String get loggedWorn => 'Logged as worn';

  @override
  String get deleteGarment => 'Delete Garment';

  @override
  String get deleteGarmentBody =>
      'This garment will be permanently removed from your wardrobe.';

  @override
  String get buildOutfit => 'Build Outfit';

  @override
  String get outfitNameHint => 'Outfit name';

  @override
  String get outfitNameRequired => 'Give your outfit a name';

  @override
  String get selectGarment => 'Select at least one garment';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String couldNotSaveOutfit(String error) {
    return 'Could not save the outfit: $error';
  }

  @override
  String get garmentsFailed => 'Failed to load garments';

  @override
  String get noGarmentsYet => 'No garments yet';

  @override
  String get noGarmentsSubtitle => 'Add garments to your closet first';

  @override
  String get outfitsFailed => 'Failed to load outfits';

  @override
  String get noOutfitsYet => 'No outfits yet';

  @override
  String get noOutfitsSubtitle =>
      'Build your first outfit by combining garments from your closet';

  @override
  String get myOutfits => 'My Outfits';

  @override
  String get aiSuggestions => 'AI Suggestions';

  @override
  String get curating => 'Curating your perfect outfits…';

  @override
  String get suggestionsFailed =>
      'Could not generate suggestions.\nTry again in a moment.';

  @override
  String get noSuggestions => 'No suggestions yet';

  @override
  String get noSuggestionsSubtitle =>
      'Add garments to your closet\nto get AI outfit recommendations';

  @override
  String get outfitSaved => 'Outfit saved';

  @override
  String get outfitNotFound => 'Outfit not found';

  @override
  String wornTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Worn $count times',
      one: 'Worn 1 time',
    );
    return '$_temp0';
  }

  @override
  String get garmentsGone =>
      'The garments in this outfit are no longer in the closet';

  @override
  String get editOutfit => 'Edit Outfit';

  @override
  String get name => 'Name';

  @override
  String get deleteOutfit => 'Delete Outfit';

  @override
  String get deleteOutfitBody =>
      'This outfit will be removed, including any days it is planned on.';

  @override
  String get noOutfitsSaved => 'No outfits saved yet';

  @override
  String get pickOutfit => 'Pick an Outfit';

  @override
  String get noOutfitRecorded => 'No outfit recorded';

  @override
  String get planOutfit => 'Plan an outfit for this day';

  @override
  String get totalItems => 'Total Items';

  @override
  String get outfitsPlanned => 'Outfits Planned';

  @override
  String get wardrobeBreakdown => 'Wardrobe Breakdown';

  @override
  String get mostWorn => 'Most Worn';

  @override
  String get leastWorn => 'Least Worn';

  @override
  String get account => 'Account';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get editName => 'Edit name';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get signOut => 'Sign Out';

  @override
  String get fullName => 'Full name';

  @override
  String get nameUpdated => 'Name updated';

  @override
  String get resetEmailSent => 'Password reset email sent';

  @override
  String get deleteAccountBody =>
      'This removes your closet, outfits, and calendar. Enter your password to confirm.';

  @override
  String get password => 'Password';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get signOutBody => 'Are you sure you want to sign out?';

  @override
  String get defaultUserName => 'User';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to your wardrobe';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get email => 'Email';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get createOne => 'Create one';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle => 'Start curating your wardrobe';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get couldNotSignIn => 'Could not complete sign-in';

  @override
  String get couldNotCreateAccount => 'Could not create the account';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'Minimum 6 characters';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get emailInUse => 'An account already exists for this email';

  @override
  String get weakPassword => 'Password does not meet the requirements';

  @override
  String get userDisabled => 'This account is disabled';

  @override
  String get signInDisabled => 'Email and password sign-in is not enabled';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later';

  @override
  String get invalidCredentials => 'Email or password is incorrect';

  @override
  String get recentLoginRequired => 'Sign in again, then retry';

  @override
  String get networkError => 'Check your internet connection';

  @override
  String get signInFailed => 'Could not complete sign-in';

  @override
  String get profileSaveFailed => 'Could not save your profile';

  @override
  String get signInRequired => 'Sign in again to continue';

  @override
  String get accountDeleteFailed => 'Could not delete the account';

  @override
  String get categoryTops => 'Tops';

  @override
  String get categoryBottoms => 'Bottoms';

  @override
  String get categoryDresses => 'Dresses';

  @override
  String get categoryOuterwear => 'Outerwear';

  @override
  String get categoryShoes => 'Shoes';

  @override
  String get categoryBags => 'Bags';

  @override
  String get categoryAccessories => 'Accessories';

  @override
  String get categoryActivewear => 'Activewear';

  @override
  String get categorySwimwear => 'Swimwear';

  @override
  String get categoryUnderwear => 'Underwear';

  @override
  String get occasionCasual => 'Casual';

  @override
  String get occasionWork => 'Work';

  @override
  String get occasionFormal => 'Formal';

  @override
  String get occasionSport => 'Sport';

  @override
  String get occasionEvening => 'Evening';

  @override
  String get occasionBeach => 'Beach';

  @override
  String get occasionTravel => 'Travel';

  @override
  String get occasionDateNight => 'Date Night';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonFall => 'Fall';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get seasonAll => 'All Season';

  @override
  String get weatherHot => 'Hot';

  @override
  String get weatherMild => 'Mild';

  @override
  String get weatherCold => 'Cold';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorWhite => 'White';

  @override
  String get colorGray => 'Gray';

  @override
  String get colorBeige => 'Beige';

  @override
  String get colorBrown => 'Brown';

  @override
  String get colorNavy => 'Navy';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorRed => 'Red';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorGold => 'Gold';

  @override
  String get colorSilver => 'Silver';

  @override
  String get colorMulticolor => 'Multicolor';
}
