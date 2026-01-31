import 'package:flutter/material.dart';

/// JoSport Color Palette
/// Based on the official design system
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Brand Colors
  static const Color nationalRed = Color(0xFFEF4444); // #EF4444
  static const Color pitchGreen = Color(0xFF10B981); // #10B981
  static const Color courtOrange = Color(0xFFF97316); // #F97316

  // Neutral Colors
  static const Color carbonBlack = Color(0xFF0A0A0A); // #0A0A0A
  static const Color stadiumWhite = Color(0xFFFAFAFA); // #FAFAFA

  // Semantic Colors (Sport Modes)
  static const Color footballMode = pitchGreen;
  static const Color basketballMode = courtOrange;
  static const Color liveIndicator = pitchGreen;

  // Text Colors
  static const Color primaryText = stadiumWhite;
  static const Color secondaryText = Color(0xFF9CA3AF); // Gray-400
  static const Color tertiaryText = Color(0xFF6B7280); // Gray-500
  static const Color textSecondary = Color(0xFF9CA3AF); // Gray-400
  static const Color textTertiary = Color(0xFF6B7280); // Gray-500
  static const Color textDisabled = Color(0xFF4B5563); // Gray-600

  // Background Colors
  static const Color scaffoldBackground = carbonBlack;
  static const Color cardBackground = Color(0xFF1F1F1F); // #1F1F1F
  static const Color inputBackground = Color(0xFF2A2A2A); // #2A2A2A

  // Interactive Colors
  static const Color buttonPrimary = nationalRed;
  static const Color buttonDisabled = Color(0xFF374151); // Gray-700
  static const Color divider = Color(0xFF374151); // Gray-700
  static const Color border = Color(0xFF374151); // Gray-700

  // Status Colors
  static const Color success = pitchGreen;
  static const Color error = nationalRed;
  static const Color warning = courtOrange;
}