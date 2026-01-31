import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ===================================================
  // DISPLAY — Main screen titles (Welcome Back, etc.)
  // ===================================================
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w600, // lighter & modern
    color: AppColors.primaryText,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: -0.2,
    height: 1.3,
  );

  // ===================================================
  // SUBTITLE — Supporting text under titles
  // ===================================================
  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary.withOpacity(0.85),
    height: 1.6,
  );

  // ===================================================
  // HEADINGS — Section titles
  // ===================================================
  static TextStyle headingLarge = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: -0.2,
  );

  static TextStyle headingMedium = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle headingSmall = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  // ===================================================
  // BODY — Normal readable text
  // ===================================================
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ===================================================
  // BUTTON — Primary & secondary buttons
  // ===================================================
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.primaryText,
  );

  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.primaryText,
  );

  // ===================================================
  // LABELS — Above input fields
  // ===================================================
  static TextStyle label = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500, // softer than before
    color: AppColors.primaryText,
  );

  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  // ===================================================
  // OVERLINE — "OR CONTINUE WITH"
  // ===================================================
  static TextStyle overline = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 1.2,
  );

  // ===================================================
  // CAPTION — Small helper / error text
  // ===================================================
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===================================================
  // INPUT — TextField text & hint
  // ===================================================
  static TextStyle input = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static TextStyle inputText = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static TextStyle inputHint = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );
}
