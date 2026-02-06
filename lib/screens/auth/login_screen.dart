import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/config/theme/app_colors.dart';
import '/config/theme/text_styles.dart';
import '/widgets/common/custom_button.dart';
import '/widgets/common/custom_text_field.dart';
import '/providers/auth_provider.dart';
import 'signIn_screen.dart';
import 'forgetPassword_screen.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Login failed'),
            backgroundColor: AppColors.nationalRed,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (!mounted) return;

    if (success) {
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Google login failed'),
          backgroundColor: AppColors.nationalRed,
        ),
      );
    }
  }

  void _handleAppleLogin() {
    // TODO: Implement Apple login when ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple login coming soon!'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48),

                          // Logo
                          Image.asset(
                            'assets/images/logo.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),

                          // Title
                          Text(
                            'Welcome Back, Nashama!',
                            style: AppTextStyles.displayLarge,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            'Sign in to your account to continue',
                            style: AppTextStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email or Phone Number',
                                style: AppTextStyles.label,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _emailController,
                                hint: 'e.g. nashama@josport.com',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: AppTextStyles.label,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _passwordController,
                                hint: 'Enter your password',
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _navigateToForgotPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Login Button
                          CustomButton(
                            text: 'Login',
                            onPressed: authProvider.isLoading ? null : _handleLogin,
                            type: ButtonType.primary,
                          ),

                          const SizedBox(height: 28),

                          // OR Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: AppTextStyles.overline,
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Button
                              InkWell(
                                onTap: authProvider.isLoading ? null : _handleGoogleLogin,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/google.png',
                                      width: 28,
                                      height: 28,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.g_mobiledata,
                                          size: 32,
                                          color: AppColors.stadiumWhite,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Apple Button
                              InkWell(
                                onTap: authProvider.isLoading ? null : _handleAppleLogin,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.apple,
                                      size: 32,
                                      color: AppColors.stadiumWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignUp,
                                child: Text(
                                  'Sign Up',
                                  style: AppTextStyles.bodySmall.copyWith(
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

                // Loading Indicator Overlay
                if (authProvider.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.courtOrange,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}