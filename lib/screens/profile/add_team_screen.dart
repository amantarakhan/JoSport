import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../models/team_model.dart';
import '../../../utils/team_logo_helper.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({super.key});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  // Sample teams - in a real app, this would come from a database
  final List<TeamModel> _availableTeams = [
    TeamModel(id: '1', name: 'Al-Wehdat', colorHex: '#10B981'),
    TeamModel(id: '2', name: 'Al-Faisaly', colorHex: '#3B82F6'),
    TeamModel(id: '3', name: 'Al-Ramtha', colorHex: '#EF4444'),
    TeamModel(id: '4', name: 'Al-Jazeera', colorHex: '#F59E0B'),
    TeamModel(id: '5', name: 'Al-Salt', colorHex: '#8B5CF6'),
    TeamModel(id: '6', name: 'Shabab Al-Ordon', colorHex: '#EC4899'),
    TeamModel(id: '7', name: 'Al-Hussein Irbid', colorHex: '#14B8A6'),
    TeamModel(id: '8', name: 'That Ras', colorHex: '#6366F1'),
  ];

  String _searchQuery = '';

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
          'Add Team',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              style: AppTextStyles.input,
              decoration: InputDecoration(
                hintText: 'Search teams...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textTertiary,
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Teams List
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final followedTeamIds = userProvider.followedTeams.map((t) => t.id).toSet();

                final filteredTeams = _availableTeams.where((team) {
                  final matchesSearch = team.name.toLowerCase().contains(_searchQuery);
                  final notFollowed = !followedTeamIds.contains(team.id);
                  return matchesSearch && notFollowed;
                }).toList();

                if (filteredTeams.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No teams found',
                          style: AppTextStyles.headingMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: filteredTeams.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final team = filteredTeams[index];
                    return _buildTeamItem(context, team, userProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamItem(BuildContext context, TeamModel team, UserProvider userProvider) {
    return GestureDetector(
      onTap: () {
        userProvider.addFollowedTeam(team);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${team.name} added to your teams'),
            backgroundColor: AppColors.pitchGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
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
            const Icon(
              Icons.add_circle_rounded,
              color: AppColors.pitchGreen,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}