import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';

/// Custom Text Field Widget for JoSport
/// Provides consistent styling and behavior across all input fields
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  bool _isFocused = false;
  late FocusNode _focusNode;

  static const double _radius = 28; // ✅ pill style like wireframes

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  OutlineInputBorder _border({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(
        color: color ?? Colors.transparent,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color focusColor = AppColors.nationalRed.withOpacity(0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMedium.copyWith(
              color: _isFocused ? AppColors.primaryText : AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
        ],

        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: widget.enabled
                ? AppColors.inputBackground
                : AppColors.cardBackground,

            // Prefix Icon
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(left: 10, right: 6),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused
                    ? AppColors.primaryText
                    : AppColors.textTertiary,
                size: 20,
              ),
            )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),

            // Suffix Icon
            suffixIcon: _buildSuffixIcon(),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),

            // Borders (soft + modern)
            border: _border(),
            enabledBorder: _border(color: AppColors.border.withOpacity(0.55)),
            focusedBorder: _border(color: focusColor, width: 1.5),
            errorBorder: _border(color: AppColors.error.withOpacity(0.9), width: 1.5),
            focusedErrorBorder:
            _border(color: AppColors.error.withOpacity(0.95), width: 1.8),
            disabledBorder: _border(color: AppColors.border.withOpacity(0.25)),

            // Padding like wireframe
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),

            counterText: '', // Hide counter
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.obscureText) {
      return IconButton(
        onPressed: _toggleObscureText,
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textTertiary,
          size: 20,
        ),
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        onPressed: widget.onSuffixIconPressed,
        icon: Icon(
          widget.suffixIcon,
          color: AppColors.textTertiary,
          size: 20,
        ),
      );
    }

    return null;
  }
}
