import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/config/theme/app_colors.dart';
import '/config/theme/text_styles.dart';
import '/widgets/common/custom_button.dart';
import '/widgets/common/custom_text_field.dart';
import '/providers/auth_provider.dart';

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

  Future<void> _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.resetPassword(_emailController.text.trim());

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email'),
            backgroundColor: AppColors.success,
          ),
        );

        // Wait a bit and then go back to login screen
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to send reset link'),
            backgroundColor: AppColors.nationalRed,
          ),
        );
      }
    }
  }

  void _handleContactSupport() {
    // TODO: Navigate to support or open email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support: support@josport.com'),
        backgroundColor: AppColors.textSecondary,
      ),
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
                              'Enter the email associated with your account and we will send a link to reset your password.',
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
                            onPressed: authProvider.isLoading ? null : _handleSendResetLink,
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