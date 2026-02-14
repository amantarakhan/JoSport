import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import 'player_details_screen.dart';
import '../../utils/player_photo_helper.dart';

class PlayersListScreen extends StatefulWidget {
  final String? sport; // null = show all, 'basketball' or 'football' = filtered
  final bool nationalTeamOnly;

  const PlayersListScreen({
    Key? key,
    this.sport,
    this.nationalTeamOnly = true,
  }) : super(key: key);

  @override
  State<PlayersListScreen> createState() => _PlayersListScreenState();
}

class _PlayersListScreenState extends State<PlayersListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String? _selectedSport;

  @override
  void initState() {
    super.initState();
    _selectedSport = widget.sport;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        title: Text(
          'Players',
          style: AppTextStyles.headingLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primaryText),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.border.withOpacity(0.5),
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Search Nashama...',
                  hintStyle: AppTextStyles.inputHint,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          // Sport filter chips (if not pre-filtered)
          if (widget.sport == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Football', 'football'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Basketball', 'basketball'),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Players list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading players',
                      style: AppTextStyles.bodyMedium.copyWith(
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

                var players = snapshot.data?.docs ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  players = players.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toLowerCase();
                    return name.contains(_searchQuery);
                  }).toList();
                }

                if (players.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports,
                          size: 64,
                          color: AppColors.textTertiary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No players found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: players.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final playerData = players[index].data() as Map<String, dynamic>;
                    final playerId = players[index].id;
                    return _buildPlayerCard(playerData, playerId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _buildQuery() {
    Query query = _firestore.collection('players');

    // Filter by national team if specified
    if (widget.nationalTeamOnly) {
      query = query.where('category', isEqualTo: 'national_team');
      query = query.where('nationalTeam', isEqualTo: 'Jordan');
    }

    // Filter by sport if selected
    if (_selectedSport != null) {
      query = query.where('sport', isEqualTo: _selectedSport);
    }

    return query.snapshots();
  }

  Widget _buildFilterChip(String label, String? sport) {
    final isSelected = _selectedSport == sport;
    final Color color = sport == 'basketball'
        ? AppColors.courtOrange
        : sport == 'football'
        ? AppColors.pitchGreen
        : AppColors.nationalRed;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSport = sport;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player, String playerId) {
    final String name = player['name'] ?? 'Unknown';
    final String position = player['position'] ?? player['primaryRole'] ?? '';
    final String currentClub = player['currentClub'] ?? '';
    final String sport = player['sport'] ?? 'football';
    final num? goals = player['goals'];
    final num? value = player['marketValue'];
    final num? rating = player['rating'];

    final Color sportColor = sport == 'basketball'
        ? AppColors.courtOrange
        : AppColors.pitchGreen;

    // Status indicator color
    final Color statusColor = player['isPro'] == true
        ? AppColors.pitchGreen
        : player['status'] == 'active'
        ? AppColors.courtOrange
        : AppColors.error;

    return GestureDetector(
      onTap: () => _navigateToPlayerStats(playerId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            // Player avatar with status indicator - Using actual photo
            PlayerPhotoHelper.buildPlayerCardPhoto(
              playerName: name,
              size: 60,
              sport: sport,
              isPro: player['isPro'] == true,
              isActive: player['status'] == 'active',
            ),

            const SizedBox(width: 16),

            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentClub.isNotEmpty ? currentClub : 'National Team',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Rating badge
            if (rating != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: sportColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: sportColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: sportColor,
                        fontWeight: FontWeight.w700,
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

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                'Filter Players',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filter options
            ListTile(
              leading: const Icon(Icons.sports_soccer, color: AppColors.pitchGreen),
              title: Text('Football Only', style: AppTextStyles.bodyLarge),
              onTap: () {
                setState(() {
                  _selectedSport = 'football';
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.sports_basketball, color: AppColors.courtOrange),
              title: Text('Basketball Only', style: AppTextStyles.bodyLarge),
              onTap: () {
                setState(() {
                  _selectedSport = 'basketball';
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.clear, color: AppColors.textSecondary),
              title: Text('Clear Filter', style: AppTextStyles.bodyLarge),
              onTap: () {
                setState(() {
                  _selectedSport = null;
                });
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToPlayerStats(String playerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerDetailsScreen(playerId: playerId),
      ),
    );
  }
}

// PlayersTab widget for bottom navigation
class PlayersTab extends StatelessWidget {
  const PlayersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlayersListScreen(
      sport: null,
      nationalTeamOnly: true,
    );
  }
}