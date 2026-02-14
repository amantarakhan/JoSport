import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import '../../models/match_model.dart';
import '../../utils/team_logo_helper.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final bool isLive;

  const MatchCard({
    super.key,
    required this.match,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = match.isFootball
        ? AppColors.pitchGreen
        : AppColors.courtOrange;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLive
              ? accentColor.withOpacity(0.3)
              : AppColors.border.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // League name and status
          Row(
            children: [
              // League dot
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // League/Sport name
              Expanded(
                child: Text(
                  match.league.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status badge
              _buildStatusBadge(accentColor),
            ],
          ),

          const SizedBox(height: 16),

          // Match details
          Row(
            children: [
              // Home team
              Expanded(
                child: _buildTeam(match.home, true),
              ),

              // Score or time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildScore(),
              ),

              // Away team
              Expanded(
                child: _buildTeam(match.away, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(Color accentColor) {
    if (isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              match.minute,
              style: AppTextStyles.caption.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else if (match.isFinished) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.textTertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'FT',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      );
    } else {
      // Upcoming match
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _formatTime(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _formatDate(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTeam(String teamName, bool isHome) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isHome) ...[
          Flexible(
            child: Text(
              teamName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
        ],
        // Team logo - Using actual logo from assets
        TeamLogoHelper.buildTeamLogo(
          teamName: teamName,
          size: 40,
        ),
        if (isHome) ...[
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              teamName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScore() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          match.homeScore,
          style: AppTextStyles.displayMedium.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
              height: 1,
            ),
          ),
        ),
        Text(
          match.awayScore,
          style: AppTextStyles.displayMedium.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    );
  }

  String _formatTime() {
    // Extract time from "21.12. 20:30" format
    final parts = match.time.split(' ');
    if (parts.length == 2) {
      return parts[1]; // Returns "20:30"
    }
    return match.time;
  }

  String _formatDate() {
    if (match.scheduledTime == null) {
      // Try to extract date from time string "21.12. 20:30"
      final parts = match.time.split(' ');
      if (parts.isNotEmpty) {
        return parts[0]; // Returns "21.12."
      }
      return 'TBD';
    }

    final now = DateTime.now();
    final matchDate = match.scheduledTime!;

    if (DateUtils.isSameDay(now, matchDate)) {
      return 'TODAY';
    } else if (DateUtils.isSameDay(now.add(const Duration(days: 1)), matchDate)) {
      return 'TOMORROW';
    } else {
      return DateFormat('MMM d').format(matchDate).toUpperCase();
    }
  }
}