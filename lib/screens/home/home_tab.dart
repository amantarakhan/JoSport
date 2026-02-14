import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../models/match_model.dart';
import '../../../widgets/home/match_card.dart';
import '../../../widgets/home/section_header.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _matchesRef = FirebaseFirestore.instance.collection('matches');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _matchesRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.nationalRed,
                  strokeWidth: 2,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load matches',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_soccer_outlined,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No matches available',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Parse all matches
            final allMatches = snapshot.data!.docs
                .map((doc) => MatchModel.fromFirestore(doc))
                .toList();

            // Group matches by date categories
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(const Duration(days: 1));
            final yesterday = today.subtract(const Duration(days: 1));

            final Map<String, List<MatchModel>> groupedMatches = {
              'past': [],
              'yesterday': [],
              'today': [],
              'tomorrow': [],
              'future': [],
            };

            for (var match in allMatches) {
              final matchDate = _parseMatchTime(match.time);
              if (matchDate != null) {
                final matchDay = DateTime(matchDate.year, matchDate.month, matchDate.day);

                if (matchDay.isBefore(yesterday)) {
                  groupedMatches['past']!.add(match);
                } else if (matchDay.isAtSameMomentAs(yesterday)) {
                  groupedMatches['yesterday']!.add(match);
                } else if (matchDay.isAtSameMomentAs(today)) {
                  groupedMatches['today']!.add(match);
                } else if (matchDay.isAtSameMomentAs(tomorrow)) {
                  groupedMatches['tomorrow']!.add(match);
                } else {
                  groupedMatches['future']!.add(match);
                }
              } else {
                // If can't parse date, assume it's past
                groupedMatches['past']!.add(match);
              }
            }

            // Sort each group
            groupedMatches['past']!.sort((a, b) => _compareMatchTime(b, a));
            groupedMatches['yesterday']!.sort((a, b) => _compareMatchTime(a, b));
            groupedMatches['today']!.sort((a, b) => _compareMatchTime(a, b));
            groupedMatches['tomorrow']!.sort((a, b) => _compareMatchTime(a, b));
            groupedMatches['future']!.sort((a, b) => _compareMatchTime(a, b));

            // Build widgets list in order: today/tomorrow/future FIRST, then past/yesterday in REVERSE
            // This makes the list start at TODAY
            final List<Widget> widgets = [];

            // Add header
            widgets.add(_buildHeader());

            // TODAY and FUTURE sections (scrollable downward)
            if (groupedMatches['today']!.isNotEmpty) {
              widgets.add(SectionHeader(title: 'TODAY', isLive: true));
              for (var match in groupedMatches['today']!) {
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: MatchCard(match: match, isLive: false),
                  ),
                );
              }
            }

            if (groupedMatches['tomorrow']!.isNotEmpty) {
              widgets.add(SectionHeader(title: 'TOMORROW', isLive: false));
              for (var match in groupedMatches['tomorrow']!) {
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: MatchCard(match: match, isLive: false),
                  ),
                );
              }
            }

            if (groupedMatches['future']!.isNotEmpty) {
              widgets.add(SectionHeader(title: 'UPCOMING', isLive: false));
              for (var match in groupedMatches['future']!) {
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: MatchCard(match: match, isLive: false),
                  ),
                );
              }
            }

            // Add spacer
            widgets.add(const SizedBox(height: 24));

            // Count the number of "future" widgets (everything above)
            final int futureWidgetCount = widgets.length;

            // NOW add PAST sections in REVERSE order (these appear when scrolling UP)
            final List<Widget> pastWidgets = [];

            if (groupedMatches['yesterday']!.isNotEmpty) {
              pastWidgets.add(SectionHeader(title: 'YESTERDAY', isLive: false));
              for (var match in groupedMatches['yesterday']!) {
                pastWidgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: MatchCard(match: match, isLive: false),
                  ),
                );
              }
            }

            if (groupedMatches['past']!.isNotEmpty) {
              pastWidgets.add(SectionHeader(title: 'PAST MATCHES', isLive: false));
              for (var match in groupedMatches['past']!) {
                pastWidgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: MatchCard(match: match, isLive: false),
                  ),
                );
              }
            }

            // Use CustomScrollView with 'center' parameter
            // Everything before 'center' scrolls UP, everything after scrolls DOWN
            return CustomScrollView(
              center: ValueKey('center-point'),
              physics: const BouncingScrollPhysics(),
              slivers: [
                // PAST sections (scroll UP to see these)
                ...pastWidgets.reversed.map((widget) => SliverToBoxAdapter(child: widget)),

                // CENTER POINT - This is where the view starts
                SliverToBoxAdapter(
                  key: const ValueKey('center-point'),
                  child: const SizedBox.shrink(), // Invisible widget
                ),

                // CURRENT and FUTURE sections (scroll DOWN to see these)
                ...widgets.map((widget) => SliverToBoxAdapter(child: widget)),
              ],
            );
          },
        ),
      ),
    );
  }

  int _compareMatchTime(MatchModel a, MatchModel b) {
    final timeA = _parseMatchTime(a.time);
    final timeB = _parseMatchTime(b.time);

    if (timeA != null && timeB != null) {
      return timeA.compareTo(timeB);
    }
    if (timeA != null) return -1;
    if (timeB != null) return 1;
    return 0;
  }

  DateTime? _parseMatchTime(String timeString) {
    try {
      final parts = timeString.trim().split(' ');
      if (parts.length >= 2) {
        final datePart = parts[0].replaceAll('.', '');
        final timePart = parts[1];

        if (datePart.length >= 4 && timePart.contains(':')) {
          final day = int.parse(datePart.substring(0, 2));
          final month = int.parse(datePart.substring(2, 4));

          final now = DateTime.now();
          int year = now.year;

          if (month > now.month + 6) {
            year = now.year - 1;
          } else if (month < now.month - 6) {
            year = now.year + 1;
          }

          final timeComponents = timePart.split(':');
          final hour = int.parse(timeComponents[0]);
          final minute = int.parse(timeComponents[1]);

          return DateTime(year, month, day, hour, minute);
        }
      }
    } catch (e) {
      // Parsing failed
    }
    return null;
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALL SCORES',
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              color: AppColors.primaryText,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}