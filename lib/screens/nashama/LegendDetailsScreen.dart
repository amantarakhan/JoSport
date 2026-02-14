import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';

class LegendDetailsScreen extends StatefulWidget {
  final String legendId;

  const LegendDetailsScreen({
    Key? key,
    required this.legendId,
  }) : super(key: key);

  @override
  State<LegendDetailsScreen> createState() => _LegendDetailsScreenState();
}

class _LegendDetailsScreenState extends State<LegendDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _legendData;
  bool _isLoading = true;
  String? _errorMessage;

  // Gold palette for legends
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFB8860B);
  static const Color _goldMid = Color(0xFFFFC107);

  @override
  void initState() {
    super.initState();
    _loadLegendData();
  }

  Future<void> _loadLegendData() async {
    try {
      final doc = await _firestore
          .collection('legends')
          .doc(widget.legendId)
          .get();

      if (doc.exists) {
        setState(() {
          _legendData = doc.data() as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Legend not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading legend data';
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
          child: CircularProgressIndicator(color: _goldMid),
        ),
      );
    }

    if (_errorMessage != null || _legendData == null) {
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
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
          ),
        ),
      );
    }

    final String name = _legendData!['name'] ?? 'Unknown';
    final String nickname = _legendData!['nickname'] ?? '';
    final String primaryRole = _legendData!['primaryRole'] ?? '';
    final String sport = _legendData!['sport'] ?? 'football';
    final String nationalTeam = _legendData!['nationalTeam'] ?? 'Jordan';
    final String record = _legendData!['record'] ?? '';
    final String status = _legendData!['status'] ?? '';
    final bool isIcon = _legendData!['isIcon'] == true;

    final Color sportColor =
    sport == 'basketball' ? AppColors.courtOrange : AppColors.pitchGreen;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── Gold radial glow background ──
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Container(
              height: 420,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.9,
                  colors: [
                    Color(0x55FFD700),
                    Color(0x22B8860B),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Subtle diagonal lines texture ──
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Back button ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _goldLight.withOpacity(0.3),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // ── Icon badge ──
                        if (isIcon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_goldDark, _goldLight, _goldDark],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    size: 14, color: Colors.black),
                                const SizedBox(width: 6),
                                Text(
                                  'ICON',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Avatar ──
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [_goldDark, _goldLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldLight.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A1A1A),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  sport == 'basketball'
                                      ? Icons.sports_basketball
                                      : Icons.sports_soccer,
                                  size: 60,
                                  color: _goldLight,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Name ──
                        Text(
                          name,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // ── Nickname ──
                        if (nickname.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                                  colors: [_goldDark, _goldLight, _goldDark],
                                ).createShader(bounds),
                            child: Text(
                              '"$nickname"',
                              style: AppTextStyles.headingMedium.copyWith(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        // ── Sport + Role pill ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: sportColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sportColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            primaryRole.isNotEmpty
                                ? '$primaryRole • ${sport[0].toUpperCase()}${sport.substring(1)}'
                                : sport[0].toUpperCase() +
                                sport.substring(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: sportColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Record card ──
                        if (record.isNotEmpty)
                          _buildGoldCard(
                            icon: Icons.emoji_events,
                            title: 'Legacy',
                            content: record,
                          ),

                        if (record.isNotEmpty) const SizedBox(height: 16),

                        // ── Info grid ──
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoTile(
                                icon: Icons.flag,
                                label: 'National Team',
                                value: nationalTeam,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoTile(
                                icon: Icons.person_pin_circle,
                                label: 'Role',
                                value: primaryRole.isNotEmpty
                                    ? primaryRole
                                    : '—',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Status card ──
                        if (status.isNotEmpty)
                          _buildStatusBadge(status),

                        const SizedBox(height: 40),
                      ],
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

  Widget _buildGoldCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _goldLight.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _goldLight.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_goldDark, _goldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _goldLight,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _goldLight.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _goldMid, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: _goldLight.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _goldLight.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium, color: _goldMid, size: 18),
          const SizedBox(width: 10),
          Text(
            status,
            style: AppTextStyles.bodyMedium.copyWith(
              color: _goldLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}