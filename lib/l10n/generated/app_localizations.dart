import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Armario virtual'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Tu armario, curado.'**
  String get appTagline;

  /// No description provided for @appMark.
  ///
  /// In es, this message translates to:
  /// **'ARMARIO'**
  String get appMark;

  /// No description provided for @closet.
  ///
  /// In es, this message translates to:
  /// **'Armario'**
  String get closet;

  /// No description provided for @outfits.
  ///
  /// In es, this message translates to:
  /// **'Conjuntos'**
  String get outfits;

  /// No description provided for @calendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendar;

  /// No description provided for @analytics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get analytics;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @myCloset.
  ///
  /// In es, this message translates to:
  /// **'Mi armario'**
  String get myCloset;

  /// No description provided for @itemCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 prenda} other{{count} prendas}}'**
  String itemCount(int count);

  /// No description provided for @addGarment.
  ///
  /// In es, this message translates to:
  /// **'Agregar prenda'**
  String get addGarment;

  /// No description provided for @editGarment.
  ///
  /// In es, this message translates to:
  /// **'Editar prenda'**
  String get editGarment;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @or.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get or;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get all;

  /// No description provided for @camera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar nombre, marca o color'**
  String get searchHint;

  /// No description provided for @searchFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo buscar en el armario'**
  String get searchFailed;

  /// No description provided for @nothingToSearch.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay nada que buscar'**
  String get nothingToSearch;

  /// No description provided for @nothingToSearchSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Agrega una prenda y búscala por nombre, marca o color'**
  String get nothingToSearchSubtitle;

  /// No description provided for @noMatches.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get noMatches;

  /// No description provided for @noMatchesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prueba con otro nombre, marca o color'**
  String get noMatchesSubtitle;

  /// No description provided for @wardrobeFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el armario'**
  String get wardrobeFailed;

  /// No description provided for @closetEmpty.
  ///
  /// In es, this message translates to:
  /// **'Tu armario está vacío'**
  String get closetEmpty;

  /// No description provided for @closetEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Agrega tu primera prenda para empezar'**
  String get closetEmptySubtitle;

  /// No description provided for @categoryEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay {category}'**
  String categoryEmpty(String category);

  /// No description provided for @categoryEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prueba otra categoría o agrega una prenda'**
  String get categoryEmptySubtitle;

  /// No description provided for @garmentNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró la prenda'**
  String get garmentNotFound;

  /// No description provided for @couldNotSaveGarment.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la prenda: {error}'**
  String couldNotSaveGarment(String error);

  /// No description provided for @removingBackground.
  ///
  /// In es, this message translates to:
  /// **'Quitando el fondo...'**
  String get removingBackground;

  /// No description provided for @addPhotos.
  ///
  /// In es, this message translates to:
  /// **'Agregar fotos'**
  String get addPhotos;

  /// No description provided for @addPhotosHint.
  ///
  /// In es, this message translates to:
  /// **'Toca para usar la cámara o la galería'**
  String get addPhotosHint;

  /// No description provided for @removeBackground.
  ///
  /// In es, this message translates to:
  /// **'Quitar fondo'**
  String get removeBackground;

  /// No description provided for @removeBackgroundSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Se aplica en el dispositivo a las fotos nuevas'**
  String get removeBackgroundSubtitle;

  /// No description provided for @backgroundPreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando el recorte de fondo ({progress}%). Inténtalo en un momento'**
  String backgroundPreparing(int progress);

  /// No description provided for @backgroundSkipped.
  ///
  /// In es, this message translates to:
  /// **'No se pudo quitar el fondo de {skipped} de {total} fotos'**
  String backgroundSkipped(int skipped, int total);

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get nameRequired;

  /// No description provided for @enterGarmentName.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre de la prenda'**
  String get enterGarmentName;

  /// No description provided for @brand.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand;

  /// No description provided for @price.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get price;

  /// No description provided for @currency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get currency;

  /// No description provided for @categoryRequired.
  ///
  /// In es, this message translates to:
  /// **'Categoría *'**
  String get categoryRequired;

  /// No description provided for @color.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @season.
  ///
  /// In es, this message translates to:
  /// **'Temporada'**
  String get season;

  /// No description provided for @occasion.
  ///
  /// In es, this message translates to:
  /// **'Ocasión'**
  String get occasion;

  /// No description provided for @weather.
  ///
  /// In es, this message translates to:
  /// **'Clima'**
  String get weather;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @timesWorn.
  ///
  /// In es, this message translates to:
  /// **'Veces usada'**
  String get timesWorn;

  /// No description provided for @costPerWear.
  ///
  /// In es, this message translates to:
  /// **'Costo por uso'**
  String get costPerWear;

  /// No description provided for @lastWorn.
  ///
  /// In es, this message translates to:
  /// **'Último uso'**
  String get lastWorn;

  /// No description provided for @notAvailable.
  ///
  /// In es, this message translates to:
  /// **'N/D'**
  String get notAvailable;

  /// No description provided for @logWornToday.
  ///
  /// In es, this message translates to:
  /// **'Registrar uso de hoy'**
  String get logWornToday;

  /// No description provided for @loggedWorn.
  ///
  /// In es, this message translates to:
  /// **'Uso registrado'**
  String get loggedWorn;

  /// No description provided for @deleteGarment.
  ///
  /// In es, this message translates to:
  /// **'Eliminar prenda'**
  String get deleteGarment;

  /// No description provided for @deleteGarmentBody.
  ///
  /// In es, this message translates to:
  /// **'Esta prenda se quitará de tu armario para siempre.'**
  String get deleteGarmentBody;

  /// No description provided for @buildOutfit.
  ///
  /// In es, this message translates to:
  /// **'Crear conjunto'**
  String get buildOutfit;

  /// No description provided for @outfitNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del conjunto'**
  String get outfitNameHint;

  /// No description provided for @outfitNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre al conjunto'**
  String get outfitNameRequired;

  /// No description provided for @selectGarment.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos una prenda'**
  String get selectGarment;

  /// No description provided for @selectedCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 elegida} other{{count} elegidas}}'**
  String selectedCount(int count);

  /// No description provided for @couldNotSaveOutfit.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar el conjunto: {error}'**
  String couldNotSaveOutfit(String error);

  /// No description provided for @garmentsFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar las prendas'**
  String get garmentsFailed;

  /// No description provided for @noGarmentsYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay prendas'**
  String get noGarmentsYet;

  /// No description provided for @noGarmentsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Primero agrega prendas a tu armario'**
  String get noGarmentsSubtitle;

  /// No description provided for @outfitsFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los conjuntos'**
  String get outfitsFailed;

  /// No description provided for @noOutfitsYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay conjuntos'**
  String get noOutfitsYet;

  /// No description provided for @noOutfitsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Arma tu primer conjunto con prendas de tu armario'**
  String get noOutfitsSubtitle;

  /// No description provided for @myOutfits.
  ///
  /// In es, this message translates to:
  /// **'Mis conjuntos'**
  String get myOutfits;

  /// No description provided for @aiSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Sugerencias'**
  String get aiSuggestions;

  /// No description provided for @curating.
  ///
  /// In es, this message translates to:
  /// **'Preparando tus conjuntos…'**
  String get curating;

  /// No description provided for @suggestionsFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron generar sugerencias.\nInténtalo en un momento.'**
  String get suggestionsFailed;

  /// No description provided for @noSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay sugerencias'**
  String get noSuggestions;

  /// No description provided for @noSuggestionsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Agrega prendas a tu armario\npara recibir recomendaciones'**
  String get noSuggestionsSubtitle;

  /// No description provided for @outfitSaved.
  ///
  /// In es, this message translates to:
  /// **'Conjunto guardado'**
  String get outfitSaved;

  /// No description provided for @outfitNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el conjunto'**
  String get outfitNotFound;

  /// No description provided for @wornTimes.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Usado 1 vez} other{Usado {count} veces}}'**
  String wornTimes(int count);

  /// No description provided for @garmentsGone.
  ///
  /// In es, this message translates to:
  /// **'Las prendas de este conjunto ya no están en el armario'**
  String get garmentsGone;

  /// No description provided for @editOutfit.
  ///
  /// In es, this message translates to:
  /// **'Editar conjunto'**
  String get editOutfit;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @deleteOutfit.
  ///
  /// In es, this message translates to:
  /// **'Eliminar conjunto'**
  String get deleteOutfit;

  /// No description provided for @deleteOutfitBody.
  ///
  /// In es, this message translates to:
  /// **'Se quitará este conjunto, incluidos los días en los que está planeado.'**
  String get deleteOutfitBody;

  /// No description provided for @noOutfitsSaved.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay conjuntos guardados'**
  String get noOutfitsSaved;

  /// No description provided for @pickOutfit.
  ///
  /// In es, this message translates to:
  /// **'Elegir conjunto'**
  String get pickOutfit;

  /// No description provided for @noOutfitRecorded.
  ///
  /// In es, this message translates to:
  /// **'No hay un conjunto registrado'**
  String get noOutfitRecorded;

  /// No description provided for @planOutfit.
  ///
  /// In es, this message translates to:
  /// **'Planea un conjunto para este día'**
  String get planOutfit;

  /// No description provided for @totalItems.
  ///
  /// In es, this message translates to:
  /// **'Prendas'**
  String get totalItems;

  /// No description provided for @outfitsPlanned.
  ///
  /// In es, this message translates to:
  /// **'Conjuntos planeados'**
  String get outfitsPlanned;

  /// No description provided for @wardrobeBreakdown.
  ///
  /// In es, this message translates to:
  /// **'Composición'**
  String get wardrobeBreakdown;

  /// No description provided for @mostWorn.
  ///
  /// In es, this message translates to:
  /// **'Más usadas'**
  String get mostWorn;

  /// No description provided for @leastWorn.
  ///
  /// In es, this message translates to:
  /// **'Menos usadas'**
  String get leastWorn;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @editName.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre'**
  String get editName;

  /// No description provided for @resetPassword.
  ///
  /// In es, this message translates to:
  /// **'Restablecer contraseña'**
  String get resetPassword;

  /// No description provided for @deleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get deleteAccount;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get appVersion;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @fullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullName;

  /// No description provided for @nameUpdated.
  ///
  /// In es, this message translates to:
  /// **'Nombre actualizado'**
  String get nameUpdated;

  /// No description provided for @resetEmailSent.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos el correo para restablecer la contraseña'**
  String get resetEmailSent;

  /// No description provided for @deleteAccountBody.
  ///
  /// In es, this message translates to:
  /// **'Esto borra tu armario, tus conjuntos y tu calendario. Escribe tu contraseña para confirmar.'**
  String get deleteAccountBody;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @signOutTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOutTitle;

  /// No description provided for @signOutBody.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres cerrar sesión?'**
  String get signOutBody;

  /// No description provided for @defaultUserName.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get defaultUserName;

  /// No description provided for @welcomeBack.
  ///
  /// In es, this message translates to:
  /// **'Hola de nuevo'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Entra a tu armario'**
  String get signInSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get email;

  /// No description provided for @noAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? '**
  String get noAccount;

  /// No description provided for @createOne.
  ///
  /// In es, this message translates to:
  /// **'Crear una'**
  String get createOne;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Empieza a armar tu armario'**
  String get createAccountSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get alreadyHaveAccount;

  /// No description provided for @couldNotSignIn.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión'**
  String get couldNotSignIn;

  /// No description provided for @couldNotCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear la cuenta'**
  String get couldNotCreateAccount;

  /// No description provided for @invalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordTooShort;

  /// No description provided for @enterYourName.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu nombre'**
  String get enterYourName;

  /// No description provided for @emailInUse.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con ese correo'**
  String get emailInUse;

  /// No description provided for @weakPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no cumple los requisitos'**
  String get weakPassword;

  /// No description provided for @userDisabled.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta está desactivada'**
  String get userDisabled;

  /// No description provided for @signInDisabled.
  ///
  /// In es, this message translates to:
  /// **'El ingreso con correo y contraseña no está habilitado'**
  String get signInDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Inténtalo más tarde'**
  String get tooManyRequests;

  /// No description provided for @invalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'El correo o la contraseña no son correctos'**
  String get invalidCredentials;

  /// No description provided for @recentLoginRequired.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a entrar e inténtalo de nuevo'**
  String get recentLoginRequired;

  /// No description provided for @networkError.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu conexión a internet'**
  String get networkError;

  /// No description provided for @signInFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar el ingreso'**
  String get signInFailed;

  /// No description provided for @profileSaveFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar tu perfil'**
  String get profileSaveFailed;

  /// No description provided for @signInRequired.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a entrar para continuar'**
  String get signInRequired;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar la cuenta'**
  String get accountDeleteFailed;

  /// No description provided for @categoryTops.
  ///
  /// In es, this message translates to:
  /// **'Partes de arriba'**
  String get categoryTops;

  /// No description provided for @categoryBottoms.
  ///
  /// In es, this message translates to:
  /// **'Partes de abajo'**
  String get categoryBottoms;

  /// No description provided for @categoryDresses.
  ///
  /// In es, this message translates to:
  /// **'Vestidos'**
  String get categoryDresses;

  /// No description provided for @categoryOuterwear.
  ///
  /// In es, this message translates to:
  /// **'Abrigos'**
  String get categoryOuterwear;

  /// No description provided for @categoryShoes.
  ///
  /// In es, this message translates to:
  /// **'Zapatos'**
  String get categoryShoes;

  /// No description provided for @categoryBags.
  ///
  /// In es, this message translates to:
  /// **'Bolsos'**
  String get categoryBags;

  /// No description provided for @categoryAccessories.
  ///
  /// In es, this message translates to:
  /// **'Accesorios'**
  String get categoryAccessories;

  /// No description provided for @categoryActivewear.
  ///
  /// In es, this message translates to:
  /// **'Ropa deportiva'**
  String get categoryActivewear;

  /// No description provided for @categorySwimwear.
  ///
  /// In es, this message translates to:
  /// **'Ropa de baño'**
  String get categorySwimwear;

  /// No description provided for @categoryUnderwear.
  ///
  /// In es, this message translates to:
  /// **'Ropa interior'**
  String get categoryUnderwear;

  /// No description provided for @occasionCasual.
  ///
  /// In es, this message translates to:
  /// **'Casual'**
  String get occasionCasual;

  /// No description provided for @occasionWork.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get occasionWork;

  /// No description provided for @occasionFormal.
  ///
  /// In es, this message translates to:
  /// **'Formal'**
  String get occasionFormal;

  /// No description provided for @occasionSport.
  ///
  /// In es, this message translates to:
  /// **'Deporte'**
  String get occasionSport;

  /// No description provided for @occasionEvening.
  ///
  /// In es, this message translates to:
  /// **'Noche'**
  String get occasionEvening;

  /// No description provided for @occasionBeach.
  ///
  /// In es, this message translates to:
  /// **'Playa'**
  String get occasionBeach;

  /// No description provided for @occasionTravel.
  ///
  /// In es, this message translates to:
  /// **'Viaje'**
  String get occasionTravel;

  /// No description provided for @occasionDateNight.
  ///
  /// In es, this message translates to:
  /// **'Cita'**
  String get occasionDateNight;

  /// No description provided for @seasonSpring.
  ///
  /// In es, this message translates to:
  /// **'Primavera'**
  String get seasonSpring;

  /// No description provided for @seasonSummer.
  ///
  /// In es, this message translates to:
  /// **'Verano'**
  String get seasonSummer;

  /// No description provided for @seasonFall.
  ///
  /// In es, this message translates to:
  /// **'Otoño'**
  String get seasonFall;

  /// No description provided for @seasonWinter.
  ///
  /// In es, this message translates to:
  /// **'Invierno'**
  String get seasonWinter;

  /// No description provided for @seasonAll.
  ///
  /// In es, this message translates to:
  /// **'Todo el año'**
  String get seasonAll;

  /// No description provided for @weatherHot.
  ///
  /// In es, this message translates to:
  /// **'Calor'**
  String get weatherHot;

  /// No description provided for @weatherMild.
  ///
  /// In es, this message translates to:
  /// **'Templado'**
  String get weatherMild;

  /// No description provided for @weatherCold.
  ///
  /// In es, this message translates to:
  /// **'Frío'**
  String get weatherCold;

  /// No description provided for @weatherRainy.
  ///
  /// In es, this message translates to:
  /// **'Lluvia'**
  String get weatherRainy;

  /// No description provided for @colorBlack.
  ///
  /// In es, this message translates to:
  /// **'Negro'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In es, this message translates to:
  /// **'Blanco'**
  String get colorWhite;

  /// No description provided for @colorGray.
  ///
  /// In es, this message translates to:
  /// **'Gris'**
  String get colorGray;

  /// No description provided for @colorBeige.
  ///
  /// In es, this message translates to:
  /// **'Beige'**
  String get colorBeige;

  /// No description provided for @colorBrown.
  ///
  /// In es, this message translates to:
  /// **'Café'**
  String get colorBrown;

  /// No description provided for @colorNavy.
  ///
  /// In es, this message translates to:
  /// **'Azul marino'**
  String get colorNavy;

  /// No description provided for @colorBlue.
  ///
  /// In es, this message translates to:
  /// **'Azul'**
  String get colorBlue;

  /// No description provided for @colorGreen.
  ///
  /// In es, this message translates to:
  /// **'Verde'**
  String get colorGreen;

  /// No description provided for @colorRed.
  ///
  /// In es, this message translates to:
  /// **'Rojo'**
  String get colorRed;

  /// No description provided for @colorPink.
  ///
  /// In es, this message translates to:
  /// **'Rosa'**
  String get colorPink;

  /// No description provided for @colorPurple.
  ///
  /// In es, this message translates to:
  /// **'Morado'**
  String get colorPurple;

  /// No description provided for @colorYellow.
  ///
  /// In es, this message translates to:
  /// **'Amarillo'**
  String get colorYellow;

  /// No description provided for @colorOrange.
  ///
  /// In es, this message translates to:
  /// **'Naranja'**
  String get colorOrange;

  /// No description provided for @colorGold.
  ///
  /// In es, this message translates to:
  /// **'Dorado'**
  String get colorGold;

  /// No description provided for @colorSilver.
  ///
  /// In es, this message translates to:
  /// **'Plateado'**
  String get colorSilver;

  /// No description provided for @colorMulticolor.
  ///
  /// In es, this message translates to:
  /// **'Multicolor'**
  String get colorMulticolor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
