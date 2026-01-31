import 'package:flutter/material.dart';
import '/config/theme/app_colors.dart';
import '/config/theme/text_styles.dart';
import '/widgets/common/custom_button.dart';
import '/widgets/common/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement sign up logic
      print('Sign up with: ${_emailController.text}');
    }
  }

  void _handleGoogleSignUp() {
    // TODO: Implement Google sign up
    print('Google sign up pressed');
  }

  void _handleAppleSignUp() {
    // TODO: Implement Apple sign up
    print('Apple sign up pressed');
  }

  void _navigateToLogin() {
    Navigator.pop(context);
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

                  // Back Button
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

                  Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),

                  Text(
                    'Welcome to JoSport',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Create an account to track your progress.',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Google Sign Up
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: _handleGoogleSignUp,
                    type: ButtonType.social,
                    icon: Icons.g_mobiledata,
                  ),

                  const SizedBox(height: 16),

                  // Apple Sign Up
                  CustomButton(
                    text: 'Continue with Apple',
                    onPressed: _handleAppleSignUp,
                    type: ButtonType.social,
                    icon: Icons.apple,
                  ),

                  const SizedBox(height: 32),

                  // OR Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppColors.textTertiary,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR USE EMAIL',
                          style: AppTextStyles.overline,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppColors.textTertiary,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email',
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

                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // ✅ FIXED: this is Sign Up screen, so button text must be "Sign Up"
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: _handleSignUp,
                    type: ButtonType.primary,
                  ),

                  const SizedBox(height: 32),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text(
                          'Login',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.nationalRed,
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
