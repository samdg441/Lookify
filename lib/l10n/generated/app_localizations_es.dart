// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Armario virtual';

  @override
  String get appTagline => 'Tu armario, curado.';

  @override
  String get appMark => 'ARMARIO';

  @override
  String get closet => 'Armario';

  @override
  String get outfits => 'Conjuntos';

  @override
  String get calendar => 'Calendario';

  @override
  String get analytics => 'Estadísticas';

  @override
  String get profile => 'Perfil';

  @override
  String get myCloset => 'Mi armario';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prendas',
      one: '1 prenda',
    );
    return '$_temp0';
  }

  @override
  String get addGarment => 'Agregar prenda';

  @override
  String get editGarment => 'Editar prenda';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Reintentar';

  @override
  String get clear => 'Limpiar';

  @override
  String get or => 'o';

  @override
  String get today => 'Hoy';

  @override
  String get all => 'Todas';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get searchHint => 'Buscar nombre, marca o color';

  @override
  String get searchFailed => 'No se pudo buscar en el armario';

  @override
  String get nothingToSearch => 'Todavía no hay nada que buscar';

  @override
  String get nothingToSearchSubtitle =>
      'Agrega una prenda y búscala por nombre, marca o color';

  @override
  String get noMatches => 'Sin resultados';

  @override
  String get noMatchesSubtitle => 'Prueba con otro nombre, marca o color';

  @override
  String get wardrobeFailed => 'No se pudo cargar el armario';

  @override
  String get closetEmpty => 'Tu armario está vacío';

  @override
  String get closetEmptySubtitle => 'Agrega tu primera prenda para empezar';

  @override
  String categoryEmpty(String category) {
    return 'Todavía no hay $category';
  }

  @override
  String get categoryEmptySubtitle =>
      'Prueba otra categoría o agrega una prenda';

  @override
  String get garmentNotFound => 'No se encontró la prenda';

  @override
  String couldNotSaveGarment(String error) {
    return 'No se pudo guardar la prenda: $error';
  }

  @override
  String get removingBackground => 'Quitando el fondo...';

  @override
  String get addPhotos => 'Agregar fotos';

  @override
  String get addPhotosHint => 'Toca para usar la cámara o la galería';

  @override
  String get removeBackground => 'Quitar fondo';

  @override
  String get removeBackgroundSubtitle =>
      'Se aplica en el dispositivo a las fotos nuevas';

  @override
  String backgroundPreparing(int progress) {
    return 'Preparando el recorte de fondo ($progress%). Inténtalo en un momento';
  }

  @override
  String backgroundSkipped(int skipped, int total) {
    return 'No se pudo quitar el fondo de $skipped de $total fotos';
  }

  @override
  String get nameRequired => 'Nombre *';

  @override
  String get enterGarmentName => 'Escribe el nombre de la prenda';

  @override
  String get brand => 'Marca';

  @override
  String get price => 'Precio';

  @override
  String get currency => 'Moneda';

  @override
  String get categoryRequired => 'Categoría *';

  @override
  String get color => 'Color';

  @override
  String get season => 'Temporada';

  @override
  String get occasion => 'Ocasión';

  @override
  String get weather => 'Clima';

  @override
  String get notes => 'Notas';

  @override
  String get timesWorn => 'Veces usada';

  @override
  String get costPerWear => 'Costo por uso';

  @override
  String get lastWorn => 'Último uso';

  @override
  String get notAvailable => 'N/D';

  @override
  String get logWornToday => 'Registrar uso de hoy';

  @override
  String get loggedWorn => 'Uso registrado';

  @override
  String get deleteGarment => 'Eliminar prenda';

  @override
  String get deleteGarmentBody =>
      'Esta prenda se quitará de tu armario para siempre.';

  @override
  String get buildOutfit => 'Crear conjunto';

  @override
  String get outfitNameHint => 'Nombre del conjunto';

  @override
  String get outfitNameRequired => 'Ponle un nombre al conjunto';

  @override
  String get selectGarment => 'Elige al menos una prenda';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elegidas',
      one: '1 elegida',
    );
    return '$_temp0';
  }

  @override
  String couldNotSaveOutfit(String error) {
    return 'No se pudo guardar el conjunto: $error';
  }

  @override
  String get garmentsFailed => 'No se pudieron cargar las prendas';

  @override
  String get noGarmentsYet => 'Todavía no hay prendas';

  @override
  String get noGarmentsSubtitle => 'Primero agrega prendas a tu armario';

  @override
  String get outfitsFailed => 'No se pudieron cargar los conjuntos';

  @override
  String get noOutfitsYet => 'Todavía no hay conjuntos';

  @override
  String get noOutfitsSubtitle =>
      'Arma tu primer conjunto con prendas de tu armario';

  @override
  String get myOutfits => 'Mis conjuntos';

  @override
  String get aiSuggestions => 'Sugerencias';

  @override
  String get curating => 'Preparando tus conjuntos…';

  @override
  String get suggestionsFailed =>
      'No se pudieron generar sugerencias.\nInténtalo en un momento.';

  @override
  String get noSuggestions => 'Todavía no hay sugerencias';

  @override
  String get noSuggestionsSubtitle =>
      'Agrega prendas a tu armario\npara recibir recomendaciones';

  @override
  String get outfitSaved => 'Conjunto guardado';

  @override
  String get outfitNotFound => 'No se encontró el conjunto';

  @override
  String wornTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usado $count veces',
      one: 'Usado 1 vez',
    );
    return '$_temp0';
  }

  @override
  String get garmentsGone =>
      'Las prendas de este conjunto ya no están en el armario';

  @override
  String get editOutfit => 'Editar conjunto';

  @override
  String get name => 'Nombre';

  @override
  String get deleteOutfit => 'Eliminar conjunto';

  @override
  String get deleteOutfitBody =>
      'Se quitará este conjunto, incluidos los días en los que está planeado.';

  @override
  String get noOutfitsSaved => 'Todavía no hay conjuntos guardados';

  @override
  String get pickOutfit => 'Elegir conjunto';

  @override
  String get noOutfitRecorded => 'No hay un conjunto registrado';

  @override
  String get planOutfit => 'Planea un conjunto para este día';

  @override
  String get totalItems => 'Prendas';

  @override
  String get outfitsPlanned => 'Conjuntos planeados';

  @override
  String get wardrobeBreakdown => 'Composición';

  @override
  String get mostWorn => 'Más usadas';

  @override
  String get leastWorn => 'Menos usadas';

  @override
  String get account => 'Cuenta';

  @override
  String get preferences => 'Preferencias';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get editName => 'Editar nombre';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get saveName => 'Guardar nombre';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get passwordUpdated => 'Contraseña actualizada';

  @override
  String get currentPasswordRequired => 'Escribe tu contraseña actual';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get couldNotUpdateName => 'No se pudo actualizar tu nombre';

  @override
  String get couldNotUpdatePassword => 'No se pudo actualizar tu contraseña';

  @override
  String get currentPasswordIncorrect => 'La contraseña actual no es correcta';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get about => 'Acerca de';

  @override
  String get appVersion => 'Versión';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get nameUpdated => 'Nombre actualizado';

  @override
  String get resetEmailSent =>
      'Te enviamos el correo para restablecer la contraseña';

  @override
  String get deleteAccountBody =>
      'Esto borra tu armario, tus conjuntos y tu calendario. Escribe tu contraseña para confirmar.';

  @override
  String get password => 'Contraseña';

  @override
  String get signOutTitle => 'Cerrar sesión';

  @override
  String get signOutBody => '¿Seguro que quieres cerrar sesión?';

  @override
  String get defaultUserName => 'Usuario';

  @override
  String get welcomeBack => 'Hola de nuevo';

  @override
  String get signInSubtitle => 'Entra a tu armario';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Entrar';

  @override
  String get email => 'Correo';

  @override
  String get noAccount => '¿No tienes cuenta? ';

  @override
  String get createOne => 'Crear una';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createAccountSubtitle => 'Empieza a armar tu armario';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get couldNotSignIn => 'No se pudo iniciar sesión';

  @override
  String get couldNotCreateAccount => 'No se pudo crear la cuenta';

  @override
  String get invalidEmail => 'Escribe un correo válido';

  @override
  String get passwordTooShort => 'Mínimo 6 caracteres';

  @override
  String get enterYourName => 'Escribe tu nombre';

  @override
  String get emailInUse => 'Ya existe una cuenta con ese correo';

  @override
  String get weakPassword => 'La contraseña no cumple los requisitos';

  @override
  String get userDisabled => 'Esta cuenta está desactivada';

  @override
  String get signInDisabled =>
      'El ingreso con correo y contraseña no está habilitado';

  @override
  String get tooManyRequests => 'Demasiados intentos. Inténtalo más tarde';

  @override
  String get invalidCredentials => 'El correo o la contraseña no son correctos';

  @override
  String get recentLoginRequired => 'Vuelve a entrar e inténtalo de nuevo';

  @override
  String get networkError => 'Revisa tu conexión a internet';

  @override
  String get signInFailed => 'No se pudo completar el ingreso';

  @override
  String get profileSaveFailed => 'No se pudo guardar tu perfil';

  @override
  String get signInRequired => 'Vuelve a entrar para continuar';

  @override
  String get accountDeleteFailed => 'No se pudo eliminar la cuenta';

  @override
  String get categoryTops => 'Partes de arriba';

  @override
  String get categoryBottoms => 'Partes de abajo';

  @override
  String get categoryDresses => 'Vestidos';

  @override
  String get categoryOuterwear => 'Abrigos';

  @override
  String get categoryShoes => 'Zapatos';

  @override
  String get categoryBags => 'Bolsos';

  @override
  String get categoryAccessories => 'Accesorios';

  @override
  String get categoryActivewear => 'Ropa deportiva';

  @override
  String get categorySwimwear => 'Ropa de baño';

  @override
  String get categoryUnderwear => 'Ropa interior';

  @override
  String get occasionCasual => 'Casual';

  @override
  String get occasionWork => 'Trabajo';

  @override
  String get occasionFormal => 'Formal';

  @override
  String get occasionSport => 'Deporte';

  @override
  String get occasionEvening => 'Noche';

  @override
  String get occasionBeach => 'Playa';

  @override
  String get occasionTravel => 'Viaje';

  @override
  String get occasionDateNight => 'Cita';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Verano';

  @override
  String get seasonFall => 'Otoño';

  @override
  String get seasonWinter => 'Invierno';

  @override
  String get seasonAll => 'Todo el año';

  @override
  String get weatherHot => 'Calor';

  @override
  String get weatherMild => 'Templado';

  @override
  String get weatherCold => 'Frío';

  @override
  String get weatherRainy => 'Lluvia';

  @override
  String get colorBlack => 'Negro';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorGray => 'Gris';

  @override
  String get colorBeige => 'Beige';

  @override
  String get colorBrown => 'Café';

  @override
  String get colorNavy => 'Azul marino';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorRed => 'Rojo';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorPurple => 'Morado';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorOrange => 'Naranja';

  @override
  String get colorGold => 'Dorado';

  @override
  String get colorSilver => 'Plateado';

  @override
  String get colorMulticolor => 'Multicolor';
}
