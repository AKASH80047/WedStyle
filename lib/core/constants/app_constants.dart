// Core App Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'WedStyle';
  static const String appTagline = 'Your Wedding. Your Style. Try Before You Buy.';
  static const String appShortTagline = 'Try. Style. Celebrate.';
  static const String appVersion = '1.0.0';

  // API Base URLs
  static const String baseUrl = 'https://api.wedstyle.in/v1';
  static const String aiTryOnUrl = 'https://ai.wedstyle.in/tryon';

  // Shared Preference Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyGuestMode = 'guest_mode';

  // Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';

  // Pagination
  static const int pageSize = 20;

  // Image URLs (Local high-resolution Gujarati bridal fashion assets)
  static const List<String> heroBanners = [
    'assets/images/bridal/panetar_01.png',
    'assets/images/bridal/complete_look_01.png',
    'assets/images/garba_chaniya_choli_1791538184299.jpg',
    'assets/images/bridal/gharchola_01.png',
  ];

  static const List<String> productImages = [
    'assets/images/bridal/bridal_lehenga_01.png',
    'assets/images/bridal/panetar_01.png',
    'assets/images/bridal/gharchola_01.png',
    'assets/images/bridal/patola_01.png',
    'assets/images/bridal/bandhani_01.png',
    'assets/images/bridal/contemporary_01.png',
    'assets/images/bridal/complete_look_01.png',
    'assets/images/garba_chaniya_choli_1791538184299.jpg',
  ];

  // Occasions
  static const List<Map<String, dynamic>> occasions = [
    {'name': 'Engagement', 'icon': '💍', 'color': 0xFFE8B4B8, 'image': 'assets/images/bridal/contemporary_01.png'},
    {'name': 'Haldi', 'icon': '🌿', 'color': 0xFFF7DC6F, 'image': 'assets/images/bridal/bandhani_01.png'},
    {'name': 'Mehendi', 'icon': '🌸', 'color': 0xFF82E0AA, 'image': 'assets/images/bridal/gharchola_01.png'},
    {'name': 'Sangeet', 'icon': '💃', 'color': 0xFFBB8FCE, 'image': 'assets/images/garba_chaniya_choli_1791538184299.jpg'},
    {'name': 'Wedding', 'icon': '👑', 'color': 0xFFE74C3C, 'image': 'assets/images/bridal/panetar_01.png'},
    {'name': 'Reception', 'icon': '✨', 'color': 0xFFD4AC0D, 'image': 'assets/images/bridal/complete_look_01.png'},
  ];

  // Size options
  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL', 'Custom'];

  // Color options
  static const List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'hex': 0xFFE74C3C},
    {'name': 'Maroon', 'hex': 0xFF800000},
    {'name': 'Pink', 'hex': 0xFFFF69B4},
    {'name': 'Gold', 'hex': 0xFFD4AC0D},
    {'name': 'Green', 'hex': 0xFF27AE60},
    {'name': 'Blue', 'hex': 0xFF2980B9},
    {'name': 'Purple', 'hex': 0xFF8E44AD},
    {'name': 'Beige', 'hex': 0xFFF5F5DC},
    {'name': 'White', 'hex': 0xFFFFFFFF},
    {'name': 'Black', 'hex': 0xFF000000},
  ];
}
