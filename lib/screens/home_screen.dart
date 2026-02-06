import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/text_styles.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.logout();

    if (!context.mounted) return;

    // Navigate back to login screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo or Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.courtOrange.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.courtOrange,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.sports_basketball,
                      size: 60,
                      color: AppColors.courtOrange,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Welcome Text
                  Text(
                    'Welcome to JoSport! 🎉',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // User Info
                  if (user != null) ...[
                    Text(
                      'Hello, ${user.displayName ?? 'Nashama'}!',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.courtOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      user.email,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 40),

                  // User ID Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You are successfully logged in!',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.stadiumWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        const Divider(color: AppColors.divider),

                        const SizedBox(height: 16),

                        // User Details
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Name',
                          value: user?.displayName ?? 'Not set',
                        ),

                        const SizedBox(height: 12),

                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user?.email ?? 'No email',
                        ),

                        const SizedBox(height: 12),

                        _buildInfoRow(
                          icon: Icons.verified_user_outlined,
                          label: 'User ID',
                          value: user?.uid.substring(0, 8) ?? 'Unknown',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Coming Soon Message
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.courtOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.courtOrange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.construction,
                          color: AppColors.courtOrange,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Home screen features coming soon!\nThis is just a placeholder.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.stadiumWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Logout Button
                  CustomButton(
                    text: 'Logout',
                    onPressed: () => _handleLogout(context),
                    type: ButtonType.secondary,
                    icon: Icons.logout,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.courtOrange,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.stadiumWhite,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}