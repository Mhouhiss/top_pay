class AppConstants {
  // API Configuration
  static const String baseUrl = '';
  static const String apiVersion = '';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  static const double defaultElevation = 2.0;
  static const double smallElevation = 1.0;
  static const double largeElevation = 4.0;
  static const double extraLargeElevation = 8.0;

  // Image Constants
  static const double defaultImageSize = 100.0;
  static const double smallImageSize = 50.0;
  static const double largeImageSize = 200.0;
  static const double avatarSize = 40.0;
  static const double largeAvatarSize = 80.0;

  // List Constants
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation Constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // File Upload Constants
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Network Constants
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Cache Constants
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
}
