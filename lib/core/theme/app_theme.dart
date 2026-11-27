import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary - Royal Heritage Crimson & Velvet Wine
  static const Color primary = Color(0xFF7A1C2C);
  static const Color primaryLight = Color(0xFF9E2A3E);
  static const Color primaryDark = Color(0xFF4A0E18);

  // Secondary - Rose Gold & Blushing Coral
  static const Color secondary = Color(0xFFC27A86);
  static const Color secondaryLight = Color(0xFFDE9FA8);
  static const Color secondaryDark = Color(0xFF9E4E5B);

  // Accent - Imperial Warm Gold
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFF3E5AB);
  static const Color accentDark = Color(0xFFA68018);

  // Royal Gujarati Gold Palette
  static const Color royalGold = Color(0xFFE5B84B);
  static const Color warmCream = Color(0xFFFFFBF5);
  static const Color deepKanku = Color(0xFFBA1828);

  // Background - Luxurious Warm Off-White / Pearl
  static const Color background = Color(0xFFFDFBF9);
  static const Color backgroundSecondary = Color(0xFFF9F3EE);

  // Card & Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F2EE);

  // Text
  static const Color textPrimary = Color(0xFF22110D);
  static const Color textSecondary = Color(0xFF5C3F38);
  static const Color textTertiary = Color(0xFF8C6D65);
  static const Color textHint = Color(0xFFB59D96);

  // Status colors
  static const Color success = Color(0xFF1E824C);
  static const Color warning = Color(0xFFE67E22);
  static const Color error = Color(0xFFC0392B);
  static const Color info = Color(0xFF2471A3);

  // Misc & Luxury Gold aliases
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFA68018);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color border = Color(0xFFEADBCE);
  static const Color textLight = Color(0xFFB59D96);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEFE4DC);
  static const Color shadow = Color(0x187A1C2C);
  static const Color overlay = Color(0x804A0E18);
  static const Color star = Color(0xFFFFB300);
  static const Color discount = Color(0xFF1E824C);
  static const Color shimmerBase = Color(0xFFEDE3DC);
  static const Color shimmerHighlight = Color(0xFFFDFBF9);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        primaryContainer: AppColors.primaryLight.withOpacity(0.1),
        onPrimaryContainer: AppColors.primary,
        secondaryContainer: AppColors.secondary.withOpacity(0.1),
        onSecondaryContainer: AppColors.secondaryDark,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.divider,
        outlineVariant: AppColors.divider.withOpacity(0.5),
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.shadow,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textHint, fontSize: 14),
        errorStyle: GoogleFonts.inter(color: AppColors.error, fontSize: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withOpacity(0.12),
        side: const BorderSide(color: AppColors.divider),
        labelStyle: GoogleFonts.inter(fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.5,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.25,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary, letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary, letterSpacing: 0.5,
      ),
    );
  }
}

// Text Styles extensions
class AppTextStyles {
  static TextStyle elegantTitle = GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.5,
  );

  static TextStyle sectionTitle = GoogleFonts.playfairDisplay(
    fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.3,
  );

  static TextStyle productName = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle price = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary,
  );

  static TextStyle originalPrice = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textHint,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle discount = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success,
  );

  static TextStyle badge = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );

  static TextStyle headline = GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.5,
  );

  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle aiGlow = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accent,
    shadows: [Shadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 8)],
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double circular = 100;
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> navbar = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];
}

class GoogleFontsHelper {
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle playfairDisplay({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle cormorant({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }
}

