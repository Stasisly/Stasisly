/// Application-wide constants and configuration.
abstract final class AppConfig {
  /// App name.
  static const String appName = 'Stasisly';

  /// App version (matches pubspec).
  static const String version = '0.1.0';

  /// Maximum messages per chat session before auto-archiving.
  static const int maxMessagesPerSession = 500;

  /// Free trial duration in days.
  static const int trialDurationDays = 7;

  /// Minimum specialists in a subcategory to create a chief.
  static const int minSpecialistsForChief = 5;

  /// Default LLM temperature for specialists.
  static const double defaultTemperature = 0.3;

  /// Default max tokens for specialist responses.
  static const int defaultMaxTokens = 600;

  /// Health disclaimer text appended to health/nutrition messages.
  static const String healthDisclaimer =
      'Esta es una recomendación personalizada. '
      'No sustituye a una consulta profesional.';

  /// Categories available in the app.
  static const List<String> categories = [
    'salud',
    'nutricion',
    'fisico',
    'mental',
  ];

  /// Subcategories by category.
  static const Map<String, List<String>> subcategories = {
    'salud': [
      'cardiologia',
      'dermatologia',
      'neumologia',
      'endocrinologia',
      'gastroenterologia',
      'reumatologia',
      'neurologia',
      'pediatria',
      'geriatria',
      'psicologia_clinica',
    ],
    'nutricion': [
      'nutricion_deportiva',
      'perdida_de_peso',
      'dietas_vegetales',
      'diabetes',
      'hipertension',
      'nutricion_pediatrica',
      'suplementacion',
    ],
    'fisico': [
      'fuerza',
      'fisioterapia',
      'flexibilidad',
      'running',
      'funcional',
      'adultos_mayores',
    ],
    'mental': [
      'mindfulness',
      'ansiedad',
      'productividad',
      'sueno',
      'resiliencia',
      'autoestima',
      'descanso',
    ],
  };

  /// Pagination page size for specialist lists.
  static const int specialistPageSize = 20;

  /// Chat input max characters.
  static const int chatInputMaxLength = 2000;

  /// Max file upload size in MB.
  static const int maxFileUploadMb = 10;

  /// Supported file types for upload.
  static const List<String> supportedFileTypes = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
  ];
}
