import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Settings',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Email Section
              _buildSection(
                title: 'Email',
                child: _buildInfoItem(
                  icon: Icons.email_rounded,
                  label: 'Email Address',
                  value: user?.email ?? 'Not available',
                ),
              ),

              const SizedBox(height: 24),

              // Display Name Section
              _buildSection(
                title: 'Profile',
                child: _buildInfoItem(
                  icon: Icons.person_rounded,
                  label: 'Display Name',
                  value: user?.displayName ?? 'Not set',
                  onTap: () {
                    _showEditNameDialog(context, userProvider);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Account Actions
              _buildSection(
                title: 'Account Actions',
                child: Column(
                  children: [
                    _buildActionItem(
                      icon: Icons.lock_reset_rounded,
                      label: 'Change Password',
                      color: AppColors.courtOrange,
                      onTap: () {
                        _showPasswordResetDialog(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      color: AppColors.nationalRed,
                      onTap: () {
                        _showSignOutDialog(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.delete_forever_rounded,
                      label: 'Delete Account',
                      color: AppColors.error,
                      onTap: () {
                        _showDeleteAccountDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.edit_rounded,
                color: AppColors.textTertiary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController(text: userProvider.currentUser?.displayName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Edit Display Name', style: AppTextStyles.headingMedium),
        content: TextField(
          controller: controller,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                userProvider.updateUserProfile(displayName: controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name updated successfully'),
                    backgroundColor: AppColors.pitchGreen,
                  ),
                );
              }
            },
            child: Text('Save', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.nationalRed)),
          ),
        ],
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Change Password', style: AppTextStyles.headingMedium),
        content: Text(
          'A password reset link will be sent to your email.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset email sent!'),
                  backgroundColor: AppColors.pitchGreen,
                ),
              );
            },
            child: Text('Send', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.nationalRed)),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Sign Out', style: AppTextStyles.headingMedium),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Sign Out', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.nationalRed)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Delete Account', style: AppTextStyles.headingMedium),
        content: Text(
          'This action cannot be undone. Are you sure you want to delete your account?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion not yet implemented'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text('Delete', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}