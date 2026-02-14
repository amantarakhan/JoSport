import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/config/theme/app_colors.dart';
import '/config/theme/text_styles.dart';
import '/widgets/common/custom_button.dart';
import '/widgets/common/custom_text_field.dart';
import '/providers/auth_provider.dart';
import '/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        // Get the current user from AuthProvider
        final currentUser = authProvider.user;

        if (currentUser != null) {
          // Create UserModel from Firebase User
          final userModel = UserModel.fromFirebaseUser(currentUser);

          // Set user in UserProvider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userModel);
        }

        // Navigate to home screen (main navigation)
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Sign up failed'),
            backgroundColor: AppColors.nationalRed,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (!mounted) return;

    if (success) {
      // Get the current user from AuthProvider
      final currentUser = authProvider.user;

      if (currentUser != null) {
        // Create UserModel from Firebase User
        final userModel = UserModel.fromFirebaseUser(currentUser);

        // Set user in UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userModel);
      }

      // Navigate to home screen (main navigation)
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Google sign up failed'),
          backgroundColor: AppColors.nationalRed,
        ),
      );
    }
  }

  void _handleAppleSignUp() {
    // TODO: Implement Apple sign up when ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple sign up coming soon!'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pop(context);
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
                            onPressed: authProvider.isLoading ? null : _handleGoogleSignUp,
                            type: ButtonType.social,
                            icon: Icons.g_mobiledata,
                          ),

                          const SizedBox(height: 16),

                          // Apple Sign Up
                          CustomButton(
                            text: 'Continue with Apple',
                            onPressed: authProvider.isLoading ? null : _handleAppleSignUp,
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

                          // Name Field
                          CustomTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

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

                          // Sign Up Button
                          CustomButton(
                            text: 'Sign Up',
                            onPressed: authProvider.isLoading ? null : _handleSignUp,
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