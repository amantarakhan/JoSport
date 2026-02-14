import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../models/team_model.dart';
import '../../../utils/team_logo_helper.dart';

class EditTeamsScreen extends StatelessWidget {
  const EditTeamsScreen({super.key});

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
          'Edit Teams',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final teams = userProvider.followedTeams;

          if (teams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer_rounded,
                    size: 80,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teams to edit',
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some teams first!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: teams.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTeamItem(context, team, userProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildTeamItem(BuildContext context, TeamModel team, UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Team logo - Using actual logo from assets
          TeamLogoHelper.buildTeamLogo(
            teamName: team.name,
            size: 50,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              team.name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.nationalRed,
            ),
            onPressed: () {
              _showDeleteConfirmation(context, team, userProvider);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TeamModel team, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Remove Team',
          style: AppTextStyles.headingMedium,
        ),
        content: Text(
          'Are you sure you want to unfollow ${team.name}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              userProvider.removeFollowedTeam(team.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${team.name} removed'),
                  backgroundColor: AppColors.nationalRed,
                ),
              );
            },
            child: Text(
              'Remove',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.nationalRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}