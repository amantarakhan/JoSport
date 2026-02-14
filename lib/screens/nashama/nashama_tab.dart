import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import '../players/player_details_screen.dart';
import '../players/players_list_screen.dart';
import '/screens/nashama/LegendDetailsScreen.dart';
import '../../utils/player_photo_helper.dart';

class NashamaTab extends StatefulWidget {
  const NashamaTab({Key? key}) : super(key: key);

  @override
  State<NashamaTab> createState() => _NashamaTabState();
}

class _NashamaTabState extends State<NashamaTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hardcoded World Cup matches (only 3)
  final List<Map<String, dynamic>> _worldCupMatches = [
    {
      'opponent': 'S. Korea',
      'date': 'March 15, 2026',
      'time': '8:00 PM',
      'venue': 'Amman International Stadium',
      'competition': 'AFC Asian Cup Qualifier',
      'ticketUrl': 'https://www.fifa.com/tickets',
    },
    {
      'opponent': 'Iraq',
      'date': 'March 20, 2026',
      'time': '6:30 PM',
      'venue': 'Amman International Stadium',
      'competition': 'AFC Asian Cup Qualifier',
      'ticketUrl': 'https://www.fifa.com/tickets',
    },
    {
      'opponent': 'Oman',
      'date': 'March 25, 2026',
      'time': '7:00 PM',
      'venue': 'King Abdullah Stadium',
      'competition': 'AFC Asian Cup Qualifier',
      'ticketUrl': 'https://www.fifa.com/tickets',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        title: Text(
          'Nashama Hub',
          style: AppTextStyles.headingLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // World Cup Headline Section
            _buildWorldCupHeadline(),

            const SizedBox(height: 32),

            // Trophy Cabinet
            _buildTrophyCabinet(),

            const SizedBox(height: 32),

            // Players Section (Basketball & Football)
            _buildPlayersSection(),

            const SizedBox(height: 32),

            // Legends Section
            _buildLegendsSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ============================================
  // WORLD CUP HEADLINE SECTION
  // ============================================
  Widget _buildWorldCupHeadline() {
    return GestureDetector(
      onTap: () => _showWorldCupMatches(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFDC2626),
              Color(0xFFEF4444),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.nationalRed.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Next Match badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'NEXT MATCH',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Match info
                  Text(
                    'JORDAN VS S. KOREA',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'AFC Asian Cup Qualifier • Amman International Stadium',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Countdown timer
                  Row(
                    children: [
                      _buildCountdownBox('03', 'DAYS'),
                      const SizedBox(width: 8),
                      _buildCountdownBox('14', 'HOURS'),
                      const SizedBox(width: 8),
                      _buildCountdownBox('25', 'MINS'),
                      const SizedBox(width: 8),
                      _buildCountdownBox('00', 'SECS'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Get Tickets button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _launchURL(_worldCupMatches[0]['ticketUrl']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.nationalRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_number, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Get Tickets',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.nationalRed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.headingLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // TROPHY CABINET
  // ============================================
  Widget _buildTrophyCabinet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: AppColors.nationalRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Trophy Cabinet',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTrophyItem(
            '🏆',
            'AFC Asian Cup',
            '2023',
            AppColors.nationalRed,
          ),
          const SizedBox(height: 12),
          _buildTrophyItem(
            '🥇',
            'WAFF Championship',
            '2022',
            AppColors.courtOrange,
          ),
          const SizedBox(height: 12),
          _buildTrophyItem(
            '🏅',
            'Arab Cup Runner-up',
            '2021',
            AppColors.pitchGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyItem(String emoji, String title, String year, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  year,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // PLAYERS SECTION
  // ============================================
  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Nashama',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayersListScreen(
                        nationalTeamOnly: true,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.nationalRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Football players
        _buildSportPlayersList('football', AppColors.pitchGreen),

        const SizedBox(height: 24),

        // Basketball players
        _buildSportPlayersList('basketball', AppColors.courtOrange),
      ],
    );
  }

  Widget _buildSportPlayersList(String sport, Color sportColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                sport == 'basketball'
                    ? Icons.sports_basketball
                    : Icons.sports_soccer,
                color: sportColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                sport == 'basketball' ? 'Basketball' : 'Football',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: sportColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('players')
                .where('category', isEqualTo: 'national_team')
                .where('nationalTeam', isEqualTo: 'Jordan')
                .where('sport', isEqualTo: sport)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading players',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.nationalRed,
                  ),
                );
              }

              final players = snapshot.data?.docs ?? [];

              if (players.isEmpty) {
                return Center(
                  child: Text(
                    'No players found',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: players.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final playerData = players[index].data() as Map<String, dynamic>;
                  final playerId = players[index].id;
                  return _buildPlayerCard(
                    playerId: playerId,
                    name: playerData['name'] ?? 'Unknown',
                    nickname: playerData['nickname'] ?? '',
                    primaryRole: playerData['position'] ?? playerData['primaryRole'] ?? '',
                    sportColor: sportColor,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================
  // LEGENDS SECTION
  // ============================================
  Widget _buildLegendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.nationalRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Legends',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('legends')
                .where('nationalTeam', isEqualTo: 'Jordan')
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading legends',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.nationalRed,
                  ),
                );
              }

              final legends = snapshot.data?.docs ?? [];

              if (legends.isEmpty) {
                return Center(
                  child: Text(
                    'No legends found',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: legends.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final legendData = legends[index].data() as Map<String, dynamic>;
                  final legendId = legends[index].id;
                  final sport = legendData['sport'] ?? 'football';
                  final sportColor = sport == 'basketball'
                      ? AppColors.courtOrange
                      : AppColors.pitchGreen;

                  return _buildLegendCard(
                    legendId: legendId,
                    name: legendData['name'] ?? 'Unknown',
                    nickname: legendData['nickname'] ?? '',
                    primaryRole: legendData['primaryRole'] ?? '',
                    record: legendData['record'] ?? '',
                    sportColor: sportColor,
                    isIcon: legendData['isIcon'] == true,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard({
    required String playerId,
    required String name,
    required String nickname,
    required String primaryRole,
    required Color sportColor,
  }) {
    // Determine sport from color
    final String sport = sportColor == AppColors.courtOrange ? 'basketball' : 'football';

    return GestureDetector(
      onTap: () => _navigateToPlayerDetails(playerId),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sportColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            // Player photo (actual image)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: sportColor.withOpacity(0.2),
                child: PlayerPhotoHelper.getPlayerPhotoPath(name) != null
                    ? Image.asset(
                  PlayerPhotoHelper.getPlayerPhotoPath(name)!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon
                    return Center(
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: sportColor,
                      ),
                    );
                  },
                )
                    : Center(
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: sportColor,
                  ),
                ),
              ),
            ),

            // Player info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (nickname.isNotEmpty)
                    Text(
                      '"$nickname"',
                      style: AppTextStyles.caption.copyWith(
                        color: sportColor,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (primaryRole.isNotEmpty)
                    Text(
                      primaryRole,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  // ============================================
  // LEGEND CARD
  // ============================================

  Widget _buildLegendCard({
    required String legendId,
    required String name,
    required String nickname,
    required String primaryRole,
    required String record,
    required Color sportColor,
    required bool isIcon,
  }) {
    const Color goldLight = Color(0xFFFFD700);
    const Color goldDark = Color(0xFFB8860B);

    return GestureDetector(
      onTap: () => _navigateToLegendDetails(legendId),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1500),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: goldLight.withOpacity(0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: goldLight.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Gold header with avatar
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A1F00), Color(0xFF1A1500)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [goldDark, goldLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goldLight.withOpacity(0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1500),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 36,
                              color: goldLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isIcon)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [goldDark, goldLight],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ICON',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (nickname.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '"$nickname"',
                        style: const TextStyle(
                          color: goldLight,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (primaryRole.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        primaryRole,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLegendDetails(String legendId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegendDetailsScreen(legendId: legendId),
      ),
    );
  }

  void _navigateToPlayerDetails(String playerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerDetailsScreen(playerId: playerId),
      ),
    );
  }

  void _showWorldCupMatches(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Upcoming Matches',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _worldCupMatches.length,
              separatorBuilder: (context, index) => const Divider(
                height: 24,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final match = _worldCupMatches[index];
                return _buildMatchItem(match);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchItem(Map<String, dynamic> match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jordan vs ${match['opponent']}',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    match['competition'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.nationalRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.nationalRed.withOpacity(0.3),
                ),
              ),
              child: Text(
                match['date'],
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.nationalRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              match['time'],
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.location_on,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                match['venue'],
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _launchURL(match['ticketUrl']),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.nationalRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.confirmation_number, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Buy Tickets',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open URL'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}