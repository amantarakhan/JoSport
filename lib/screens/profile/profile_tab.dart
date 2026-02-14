import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/team_model.dart';
import 'edit_teams_screen.dart';
import 'add_team_screen.dart';
import 'account_settings_screen.dart';
import 'help_support_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // Back navigation if needed
          },
        ),
        title: Text(
          'Profile',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.nationalRed,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Profile Picture and Name Section
                _buildProfileHeader(context, user, userProvider),

                const SizedBox(height: 40),

                // Followed Teams Section
                _buildFollowedTeamsSection(context, userProvider),

                const SizedBox(height: 32),

                // Settings Section
                _buildSettingsSection(context, userProvider),

                const SizedBox(height: 24),

                // App Version
                _buildAppVersion(),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user, UserProvider userProvider) {
    // Safely get first letter of display name
    String getInitial() {
      final name = user.displayName?.trim() ?? '';
      if (name.isEmpty) return 'U';
      return name.substring(0, 1).toUpperCase();
    }

    return Column(
      children: [
        // Profile Picture with Edit Button
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardBackground,
                image: user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(user.photoUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: user.photoUrl == null || user.photoUrl!.isEmpty
                  ? Center(
                child: Text(
                  getInitial(),
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 48,
                    color: AppColors.nationalRed,
                  ),
                ),
              )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement photo picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo picker coming soon!'),
                      backgroundColor: AppColors.nationalRed,
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.nationalRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.primaryText,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // User Name
        Text(
          user.displayName?.isNotEmpty == true ? user.displayName! : 'User',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 12),

        // Pro Member Badge
        if (user.isProMember ?? false)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.courtOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.courtOrange.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.courtOrange,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Pro Member',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.courtOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFollowedTeamsSection(BuildContext context, UserProvider userProvider) {
    final teams = userProvider.followedTeams;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Followed Teams',
                style: AppTextStyles.headingMedium.copyWith(
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditTeamsScreen(),
                    ),
                  );
                },
                child: Text(
                  'Edit',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.nationalRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Teams Grid
          if (teams.isEmpty)
            _buildEmptyTeamsState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return _buildTeamCard(teams[index]);
              },
            ),

          const SizedBox(height: 16),

          // Add Another Team Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTeamScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.pitchGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.pitchGreen,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add another team',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTeamsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_soccer_rounded,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'No teams followed yet',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(TeamModel team) {
    // Parse color from hex string
    Color teamColor = AppColors.pitchGreen;
    try {
      teamColor = Color(int.parse(team.colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      // Use default color if parsing fails
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: teamColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_soccer_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              team.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTextStyles.headingMedium.copyWith(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 16),

          // Match Notifications Toggle
          _buildSettingItem(
            icon: Icons.notifications_rounded,
            iconColor: AppColors.nationalRed,
            title: 'Match Notifications',
            trailing: Switch(
              value: userProvider.matchNotifications,
              onChanged: (value) {
                userProvider.toggleMatchNotifications(value);
              },
              activeColor: AppColors.nationalRed,
              activeTrackColor: AppColors.nationalRed.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 12),

          // Sport Mode Toggle
          _buildSettingItem(
            icon: Icons.sports_basketball_rounded,
            iconColor: AppColors.courtOrange,
            title: 'Sport Mode',
            subtitle: 'Theme set to ${userProvider.sportTheme}',
            trailing: Switch(
              value: userProvider.sportMode,
              onChanged: (value) {
                userProvider.toggleSportMode(value);
              },
              activeColor: AppColors.nationalRed,
              activeTrackColor: AppColors.nationalRed.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 12),

          // Account Settings Navigation
          _buildSettingItem(
            icon: Icons.person_rounded,
            iconColor: AppColors.textSecondary,
            title: 'Account Settings',
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 18,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // Help & Support Navigation
          _buildSettingItem(
            icon: Icons.help_rounded,
            iconColor: AppColors.textSecondary,
            title: 'Help & Support',
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 18,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Center(
      child: Text(
        'JoSport v2.4.0',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}