import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../models/league_model.dart';
import '../../../widgets/common/standings_table.dart';

class LeaguesTab extends StatefulWidget {
  const LeaguesTab({super.key});

  @override
  State<LeaguesTab> createState() => _LeaguesTabState();
}

class _LeaguesTabState extends State<LeaguesTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Firebase collection reference
  final _leaguesRef = FirebaseFirestore.instance.collection('leagues');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeagueView('football_pro_league', AppColors.pitchGreen),
                  _buildLeagueView('basketball_pro_league', AppColors.courtOrange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEAGUES',
                  style: AppTextStyles.headingMedium.copyWith(
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Search functionality
            },
            icon: const Icon(Icons.search, size: 24),
            color: AppColors.primaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(),
        labelColor: AppColors.primaryText,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Container(
              decoration: BoxDecoration(
                color: _tabController.index == 0
                    ? AppColors.pitchGreen.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: _tabController.index == 0
                    ? Border.all(color: AppColors.pitchGreen.withOpacity(0.3))
                    : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Text('JORDAN PRO LEAGUE'),
            ),
          ),
          Tab(
            child: Container(
              decoration: BoxDecoration(
                color: _tabController.index == 1
                    ? AppColors.courtOrange.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: _tabController.index == 1
                    ? Border.all(color: AppColors.courtOrange.withOpacity(0.3))
                    : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Text('PREMIER BASKETBALL'),
            ),
          ),
        ],
        onTap: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildLeagueView(String documentId, Color accentColor) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _leaguesRef.doc(documentId).snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: accentColor,
              strokeWidth: 2,
            ),
          );
        }

        // Error state
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
                  'Failed to load standings',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {}); // Retry
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // No data
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No standings available',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // Parse league data
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final league = LeagueModel.fromFirestore(data);

        // Display standings
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StandingsTable(
              standings: league.standings,
              accentColor: accentColor,
              lastUpdated: league.lastUpdated,
            ),
          ),
        );
      },
    );
  }
}