import 'package:flutter/material.dart';
import '/config/theme/app_colors.dart';
import '/config/theme/text_styles.dart';
import '/widgets/common/custom_button.dart';
import '/widgets/common/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password reset logic
      print('Send reset link to: ${_emailController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _handleContactSupport() {
    // TODO: Navigate to support or open email
    print('Contact support pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.stadiumWhite,
                        size: 28,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Lock Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: 0.75,
                            strokeWidth: 3,
                            color: AppColors.courtOrange,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const Icon(
                          Icons.lock_outline,
                          size: 48,
                          color: AppColors.courtOrange,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'Reset Password',
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Enter the email associated with your account and we will send an OTP to reset your password.',
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 48),

                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'Send Reset Link',
                    onPressed: _handleSendResetLink,
                    type: ButtonType.primary,
                  ),

                  const SizedBox(height: 120),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Having trouble? ',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleContactSupport,
                        child: Text(
                          'Contact Support',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.stadiumWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
