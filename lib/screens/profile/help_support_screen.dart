import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Help & Support',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // FAQ Section
          _buildSection(
            title: 'Frequently Asked Questions',
            children: [
              _buildFAQItem(
                question: 'How do I follow a team?',
                answer: 'Go to your profile, scroll to "My Followed Teams", and tap "Add another team". Search for your favorite team and tap to follow.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                question: 'What is Pro Member?',
                answer: 'Pro Members get exclusive features like live match notifications, detailed statistics, and ad-free experience.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                question: 'How do I enable notifications?',
                answer: 'Go to Settings in your profile and toggle "Match Notifications" on. Make sure your device settings also allow notifications.',
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Contact Section
          _buildSection(
            title: 'Contact Us',
            children: [
              _buildContactItem(
                icon: Icons.email_rounded,
                title: 'Email Support',
                subtitle: 'support@josport.jo',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email client...'),
                      backgroundColor: AppColors.pitchGreen,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                icon: Icons.phone_rounded,
                title: 'Phone Support',
                subtitle: '+962 6 XXX XXXX',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening dialer...'),
                      backgroundColor: AppColors.pitchGreen,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                icon: Icons.chat_bubble_rounded,
                title: 'Live Chat',
                subtitle: 'Available 24/7',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live chat coming soon!'),
                      backgroundColor: AppColors.courtOrange,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // About Section
          _buildSection(
            title: 'About',
            children: [
              _buildInfoItem(
                icon: Icons.info_rounded,
                title: 'Version',
                subtitle: 'JoSport v2.4.0',
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening Terms of Service...'),
                      backgroundColor: AppColors.pitchGreen,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening Privacy Policy...'),
                      backgroundColor: AppColors.pitchGreen,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.nationalRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.nationalRed,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    String? subtitle,
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
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}