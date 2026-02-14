import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import '../../models/league_model.dart';
import '../../utils/team_logo_helper.dart';

class StandingsTable extends StatelessWidget {
  final List<StandingItem> standings;
  final Color accentColor;
  final DateTime? lastUpdated;

  const StandingsTable({
    super.key,
    required this.standings,
    required this.accentColor,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Last updated timestamp
        if (lastUpdated != null) _buildLastUpdated(),

        const SizedBox(height: 16),

        // Table header
        _buildTableHeader(),

        const SizedBox(height: 12),

        // Standings rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: standings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildStandingRow(standings[index], index);
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLastUpdated() {
    final timeAgo = _getTimeAgo(lastUpdated!);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            size: 14,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 6),
          Text(
            'Updated $timeAgo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Rank column
          SizedBox(
            width: 40,
            child: Text(
              'RK',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Team column
          Expanded(
            child: Text(
              'TEAM',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // MP column
          SizedBox(
            width: 50,
            child: Text(
              'MP',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // PTS column
          SizedBox(
            width: 50,
            child: Text(
              'PTS',
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingRow(StandingItem standing, int visualIndex) {
    // Highlight top 3 with accent color
    final bool isTopThree = standing.rank <= 3;
    final Color rankColor = isTopThree ? accentColor : AppColors.textTertiary;

    return Container(
      decoration: BoxDecoration(
        color: visualIndex == 0
            ? accentColor.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: visualIndex == 0
            ? Border.all(color: accentColor.withOpacity(0.2), width: 1)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          // Rank with colored indicator
          SizedBox(
            width: 40,
            child: Row(
              children: [
                // Rank indicator bar
                Container(
                  width: 3,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isTopThree ? rankColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                // Rank number
                SizedBox(
                  width: 20,
                  child: Text(
                    '${standing.rank}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isTopThree ? FontWeight.w700 : FontWeight.w600,
                      color: rankColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Team name with logo
          Expanded(
            child: Row(
              children: [
                // Team logo circle
                _buildTeamLogo(standing.team, accentColor),
                const SizedBox(width: 12),
                // Team name
                Expanded(
                  child: Text(
                    standing.team,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: visualIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Matches played
          SizedBox(
            width: 50,
            child: Text(
              '${standing.matchesPlayed}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Points (highlighted)
          SizedBox(
            width: 50,
            child: Text(
              '${standing.points}',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: accentColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String teamName, Color color) {
    // Use actual team logo from assets
    return TeamLogoHelper.buildTeamLogo(
      teamName: teamName,
      size: 36,
      fallbackColor: color,
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}