import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isLive;

  const SectionHeader({
    super.key,
    required this.title,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          // Live indicator (if live)
          if (isLive) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.nationalRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.nationalRed.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Title
          Text(
            title,
            style: AppTextStyles.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: isLive ? AppColors.primaryText : AppColors.textSecondary,
            ),
          ),

          // Live badge
          if (isLive) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.nationalRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'LIVE',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.nationalRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}