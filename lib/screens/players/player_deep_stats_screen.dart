import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';

class PlayerDeepStatsScreen extends StatefulWidget {
  final String playerId;

  const PlayerDeepStatsScreen({
    Key? key,
    required this.playerId,
  }) : super(key: key);

  @override
  State<PlayerDeepStatsScreen> createState() => _PlayerDeepStatsScreenState();
}

class _PlayerDeepStatsScreenState extends State<PlayerDeepStatsScreen> {
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
        // Try legends collection
        DocumentSnapshot legendDoc = await _firestore
            .collection('Legends')
            .doc(widget.playerId)
            .get();

        if (legendDoc.exists) {
          setState(() {
            _playerData = legendDoc.data() as Map<String, dynamic>?;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Player not found';
            _isLoading = false;
          });
        }
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
    final String position = _playerData!['position'] ?? _playerData!['primaryRole'] ?? '';
    final String currentClub = _playerData!['currentClub'] ?? '';
    final String country = _playerData!['nationalTeam'] ?? _playerData!['currentClubCountry'] ?? 'Jordan';
    final int jerseyNumber = _playerData!['jerseyNumber'] ?? 0;
    final String sport = _playerData!['sport'] ?? 'football';

    final Color sportColor = sport == 'basketball'
        ? AppColors.courtOrange
        : AppColors.pitchGreen;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0A0A), // Darker brown/black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DEEP STATS',
          style: AppTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryText),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Player header with avatar and caps
            _buildPlayerHeader(name, position, currentClub, country, jerseyNumber, sportColor),

            const SizedBox(height: 32),

            // Market Value Section
            _buildMarketValueSection(),

            const SizedBox(height: 24),

            // Stats Grid (Goals, Assists, Rating)
            _buildStatsGrid(),

            const SizedBox(height: 32),

            // Attribute Profile (Radar Chart)
            _buildAttributeProfile(),

            const SizedBox(height: 32),

            // Season Heatmap
            _buildSeasonHeatmap(),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(String name, String position, String club, String country, int jerseyNumber, Color sportColor) {
    final int caps = _playerData!['caps'] ?? 45;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Player avatar
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    sportColor,
                    sportColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.scaffoldBackground,
                  width: 4,
                ),
              ),
              child: Center(
                child: Icon(
                  _playerData!['sport'] == 'basketball'
                      ? Icons.sports_basketball
                      : Icons.sports_soccer,
                  size: 60,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),

            // Caps badge
            Positioned(
              bottom: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.nationalRed,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CAPS',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      caps.toString(),
                      style: AppTextStyles.headingSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Player name
        Text(
          name,
          style: AppTextStyles.displayMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Position and club
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _playerData!['sport'] == 'basketball'
                  ? Icons.sports_basketball
                  : Icons.sports_soccer,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              position,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            const Text('•', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            Text(
              club,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Country and Jersey
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flag, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    country,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '# $jerseyNumber',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketValueSection() {
    final num marketValue = _playerData!['marketValue'] ?? 180;
    final num valueChange = _playerData!['valueChange'] ?? 12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MARKET VALUE',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '€${marketValue}M',
                  style: AppTextStyles.displayLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.pitchGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 12,
                        color: AppColors.pitchGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+$valueChange%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.pitchGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'LAST 12 MONTHS',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Simple value chart
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.nationalRed.withOpacity(0.3),
                    AppColors.nationalRed.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: ValueChartPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final int goals = _playerData!['goals'] ?? 28;
    final int assists = _playerData!['assists'] ?? 14;
    final double rating = (_playerData!['rating'] ?? 9.2).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatBox('GOALS', goals.toString(), AppColors.cardBackground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatBox('ASSISTS', assists.toString(), AppColors.cardBackground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatBox('RATING', rating.toString(), AppColors.nationalRed),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color bgColor) {
    final bool isRating = label == 'RATING';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isRating ? Colors.white : AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: isRating ? Colors.white : AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attribute Profile',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View Details',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.nationalRed,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Radar Chart
            SizedBox(
              height: 250,
              child: CustomPaint(
                painter: RadarChartPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonHeatmap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Season Heatmap',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Football field heatmap
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B4D3E),
                    Color(0xFF0F3A2A),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Field lines
                  CustomPaint(
                    size: Size.infinite,
                    painter: FieldLinesPainter(),
                  ),
                  // Heatmap overlay
                  CustomPaint(
                    size: Size.infinite,
                    painter: HeatmapPainter(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'HIGH ACTIVITY',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Compare',
                    style: AppTextStyles.buttonMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.nationalRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.remove_red_eye, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Scout Player',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painters

class ValueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.nationalRed
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.4,
      size.width * 0.75, size.height * 0.2,
    );
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);

    // End point indicator
    canvas.drawCircle(
      Offset(size.width, size.height * 0.1),
      6,
      Paint()..color = AppColors.nationalRed,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw background hexagon
    final bgPaint = Paint()
      ..color = AppColors.textTertiary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final bgPath = _createHexagonPath(center, radius);
    canvas.drawPath(bgPath, bgPaint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.textTertiary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      canvas.drawPath(
        _createHexagonPath(center, radius * i / 3),
        gridPaint,
      );
    }

    // Draw data hexagon (player stats)
    final dataPaint = Paint()
      ..color = AppColors.nationalRed.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final dataPath = _createDataPath(center, radius);
    canvas.drawPath(dataPath, dataPaint);

    final dataStrokePaint = Paint()
      ..color = AppColors.nationalRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(dataPath, dataStrokePaint);

    // Draw data points
    final points = _getDataPoints(center, radius);
    for (final point in points) {
      canvas.drawCircle(
        point,
        4,
        Paint()..color = AppColors.nationalRed,
      );
    }

    // Draw labels
    _drawLabels(canvas, center, radius);
  }

  Path _createHexagonPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createDataPath(Offset center, double radius) {
    final values = [0.85, 0.75, 0.9, 0.7, 0.8, 0.65]; // Sample data
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final r = radius * values[i];
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  List<Offset> _getDataPoints(Offset center, double radius) {
    final values = [0.85, 0.75, 0.9, 0.7, 0.8, 0.65];
    final points = <Offset>[];

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final r = radius * values[i];
      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }
    return points;
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = ['PAC', 'SHO', '', 'DEF', 'PHY', ''];

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final x = center.dx + (radius + 25) * cos(angle);
      final y = center.dy + (radius + 25) * sin(angle);

      if (labels[i].isNotEmpty) {
        final textSpan = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FieldLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Center line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      30,
      paint,
    );

    // Penalty areas
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.25, size.width * 0.25, size.height * 0.5),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.65, size.height * 0.25, size.width * 0.25, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simulate heat zones
    final zones = [
      {'x': 0.6, 'y': 0.4, 'intensity': 0.8},
      {'x': 0.5, 'y': 0.5, 'intensity': 0.6},
      {'x': 0.7, 'y': 0.6, 'intensity': 0.7},
    ];

    for (final zone in zones) {
      final x = size.width * (zone['x'] as double);
      final y = size.height * (zone['y'] as double);
      final intensity = zone['intensity'] as double;

      final gradient = RadialGradient(
        colors: [
          Color.lerp(Colors.yellow, Colors.red, intensity)!.withOpacity(0.6),
          Colors.transparent,
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: Offset(x, y), radius: 40),
        );

      canvas.drawCircle(Offset(x, y), 40, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double cos(double angle) => (angle == 0 ? 1.0 : angle.isNegative ? -1.0 : 1.0);
double sin(double angle) => 0.0;