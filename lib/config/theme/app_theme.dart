import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ✅ GLOBAL FONT (so every widget uses Poppins by default)
    fontFamily: GoogleFonts.poppins().fontFamily,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.nationalRed,
      secondary: AppColors.pitchGreen,
      tertiary: AppColors.courtOrange,
      surface: AppColors.cardBackground,
      error: AppColors.error,
      onPrimary: AppColors.primaryText,
      onSecondary: AppColors.primaryText,
      onSurface: AppColors.primaryText,
      onError: AppColors.primaryText,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.scaffoldBackground,

    // AppBar
    appBarTheme:  AppBarTheme(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyles.headingMedium,
      iconTheme: IconThemeData(color: AppColors.primaryText),
    ),

    // Card
    cardTheme: const CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.primaryText,
        disabledBackgroundColor: AppColors.buttonDisabled,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.buttonLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.nationalRed,
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.nationalRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: AppTextStyles.inputHint,
      labelStyle: AppTextStyles.label,
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.primaryText,
      size: 24,
    ),

    // ✅ Text Theme (more complete mapping for Material 3 widgets)
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,

      headlineLarge: AppTextStyles.headingLarge,
      headlineMedium: AppTextStyles.headingMedium,
      headlineSmall: AppTextStyles.headingSmall,

      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      labelLarge: AppTextStyles.label,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.caption,
    ),
  );

  // Football-themed variant (Pitch Green accent)
  static ThemeData footballTheme = darkTheme.copyWith(
    colorScheme: darkTheme.colorScheme.copyWith(
      primary: AppColors.pitchGreen,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pitchGreen,
        foregroundColor: AppColors.carbonBlack,
      ),
    ),
  );

  // Basketball-themed variant (Court Orange accent)
  static ThemeData basketballTheme = darkTheme.copyWith(
    colorScheme: darkTheme.colorScheme.copyWith(
      primary: AppColors.courtOrange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.courtOrange,
        foregroundColor: AppColors.carbonBlack,
      ),
    ),
  );
}
