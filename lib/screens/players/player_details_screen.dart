import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import '../../utils/player_photo_helper.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final String playerId;

  const PlayerDetailsScreen({
    Key? key,
    required this.playerId,
  }) : super(key: key);

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _playerData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    try {
      DocumentSnapshot playerDoc = await _firestore
          .collection('players')
          .doc(widget.playerId)
          .get();

      if (playerDoc.exists) {
        setState(() {
          _playerData = playerDoc.data() as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Player not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading player data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.nationalRed,
          ),
        ),
      );
    }

    if (_errorMessage != null || _playerData == null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            _errorMessage ?? 'No data available',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    final String name = _playerData!['name'] ?? 'Unknown';
    final String sport = _playerData!['sport'] ?? 'football';
    final String position = _playerData!['position'] ?? _playerData!['primaryRole'] ?? '';
    final String nationalTeam = _playerData!['nationalTeam'] ?? 'Jordan';
    final String currentClub = _playerData!['currentClub'] ?? '';
    final String currentClubCountry = _playerData!['currentClubCountry'] ?? '';
    final int jerseyNumber = _playerData!['jerseyNumber'] ?? 0;
    final int? heightCm = _playerData!['heightCm'];

    final Color sportColor = sport == 'basketball'
        ? AppColors.courtOrange
        : AppColors.pitchGreen;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Gradient header background
          Container(
            height: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  sportColor,
                  sportColor.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 40),

                // Player photo (large hero style)
                PlayerPhotoHelper.buildPlayerHeroPhoto(
                  playerName: name,
                  size: 120,
                  sport: sport,
                ),

                const SizedBox(height: 24),

                // Player name
                Text(
                  name,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Info card
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Position
                          _buildInfoItem(
                            icon: Icons.person_pin_circle,
                            label: 'Position',
                            value: position,
                            color: sportColor,
                          ),

                          const SizedBox(height: 16),

                          // National Team
                          _buildInfoItem(
                            icon: Icons.flag,
                            label: 'National Team',
                            value: nationalTeam,
                            color: sportColor,
                          ),

                          const SizedBox(height: 16),

                          // Current Club
                          if (currentClub.isNotEmpty)
                            _buildInfoItem(
                              icon: Icons.sports,
                              label: 'Current Club',
                              value: currentClub,
                              color: sportColor,
                            ),

                          if (currentClub.isNotEmpty) const SizedBox(height: 16),

                          // Jersey Number
                          if (jerseyNumber > 0)
                            _buildInfoItem(
                              icon: Icons.tag,
                              label: 'Jersey Number',
                              value: '#$jerseyNumber',
                              color: sportColor,
                            ),

                          if (jerseyNumber > 0) const SizedBox(height: 16),

                          // Height
                          if (heightCm != null)
                            _buildInfoItem(
                              icon: Icons.height,
                              label: 'Height',
                              value: '$heightCm cm',
                              color: sportColor,
                            ),

                          if (heightCm != null) const SizedBox(height: 24),

                          // Playing location badge
                          if (currentClubCountry.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: sportColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: sportColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: sportColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Playing in $currentClubCountry',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: sportColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}