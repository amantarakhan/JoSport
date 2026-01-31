import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';

/// Custom Button Widget for JoSport
/// Supports primary, secondary, text, and social button styles
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(isDisabled);
      case ButtonType.secondary:
        return _buildSecondaryButton(isDisabled);
      case ButtonType.text:
        return _buildTextButton(isDisabled);
      case ButtonType.social:
        return _buildSocialButton(isDisabled);
    }
  }

  // ============================================
  // PRIMARY BUTTON (Filled / Pill)
  // ============================================
  Widget _buildPrimaryButton(bool isDisabled) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 64, // slightly taller like wireframes
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.nationalRed,
          foregroundColor: textColor ?? AppColors.stadiumWhite,
          disabledBackgroundColor: AppColors.buttonDisabled,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32), // ✅ more pill-like
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.stadiumWhite,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: AppTextStyles.buttonLarge.copyWith(
                color: textColor ?? AppColors.stadiumWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // SECONDARY BUTTON (Outlined / Soft)
  // ============================================
  Widget _buildSecondaryButton(bool isDisabled) {
    final Color accent = backgroundColor ?? AppColors.nationalRed;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 64,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          disabledForegroundColor: AppColors.textDisabled,
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isDisabled ? AppColors.textDisabled : accent.withOpacity(0.8),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: AppTextStyles.buttonLarge.copyWith(
                color: textColor ?? accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // TEXT BUTTON
  // ============================================
  Widget _buildTextButton(bool isDisabled) {
    final Color accent = backgroundColor ?? AppColors.nationalRed;

    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: accent,
        disabledForegroundColor: AppColors.textDisabled,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      child: isLoading
          ? SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(accent),
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: AppTextStyles.buttonMedium.copyWith(
              color: textColor ?? accent,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // SOCIAL BUTTON (Google/Apple)
  // ============================================
  Widget _buildSocialButton(bool isDisabled) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 64,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.inputBackground,
          foregroundColor: AppColors.stadiumWhite,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(
            color: AppColors.border.withOpacity(0.7),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32), // ✅ match main pill style
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.stadiumWhite,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: AppTextStyles.buttonLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Button types for CustomButton
enum ButtonType {
  primary, // Filled button (main CTA)
  secondary, // Outlined button
  text, // Text-only button
  social, // Social login buttons
}
