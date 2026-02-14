import 'package:flutter/material.dart';

/// Player Photo Helper - DEBUG VERSION
/// Add print statements to see what's happening
class PlayerPhotoHelper {
  // Explicit mapping for players with non-standard naming
  static final Map<String, String> _playerPhotoMap = {
    // Basketball Players (exact Firebase name → exact file name)
    'abdallah nasib': 'Abdallah Nasib.png',
    'abdul rahman olajuwon': 'Abdul Rahman Olajuwon.png',
    'abdullah olajuwon': 'Abdullah Olajuwon.png',
    'adham al-quraishi': 'Adham Al-Quraishi.png',
    'ahmad al-dwair': 'Ahmad Al-Dwair.png',
    'ahmad al-dwairi': 'Ahmad Al-Dwair.png',
    'ahmad al-hamarsheh': 'Ahmad Al-Hamarsheh.png',
    'ahmad ersan': 'Ahmad Ersan.png',
    'ahmad hassooneh': 'Ahmad Hassooneh.png',
    'ahmad hasso': 'Ahmad Hassooneh.png',
    'ahmad shaher': 'Mohammad Shaher.png',
    'mohammad shaher': 'Mohammad Shaher.png',
    'ali olwan': 'Ali Olwan.png',
    'amer jamous': 'Amer Jamous.png',
    'amin abu hawwas': 'Amin Abu Hawwas.png',
    'amin abu-hawwas': 'Amin Abu Hawwas.png',
    'basil abuabboud': 'Basil Abuabboud.png',
    'faris mucharbach': 'Faris Mucharbach.png',
    'faris muchaweh': 'Faris Mucharbach.png',
    'freddy ibrahim': 'Freddy Ibrahim.png',
    'hadi al-hourani': 'Hadi Al-Hourani.png',
    'husam abu dahab': 'Husam Abu Dahab.png',
    'ibrahim saadeh': 'Ibrahim Saadeh.png',
    'issam smeeri': 'Issam Smeeri.png',
    'mahmoud al-mardi': 'Mahmoud Al-Mardi.png',
    'malek kanaan': 'Malek Kanaan.png',
    'rondae hollis-jefferson': 'Rondae Hollis-Jefferson.png',
    'yazan altaweel': 'Yazan Altaweel.png',
    'yazan altawil': 'Yazan Altaweel.png',

    // Football Players
    'mousa al-taamari': 'Mousa Al-Taamari.png',
    'musa al-taamari': 'Musa Al-Taamari.png',
    'nizar al-rashdan': 'Nizar Al-Rashdan.png',
    'noor al-rawabdeh': 'Noor Al-Rawabdeh.png',
    'saed al-rosan': 'Saed Al-Rosan.png',
    'yazan al-arab': 'Yazan Al-Arab.png',
    'yazan al-naimat': 'Yazan Al-Naimat.png',
    'mohammad abu taha': 'Mohammad Abu Taha.png',
    'noureddin bani attah': 'Noureddin Bani Attah.png',
    'rajai ayad': 'Rajai Ayad.png',
    'saleem obaid': 'Saleem Obaid.png',
    'yazeed abu laila': 'Yazeed Abu Laila.png',
    'yousef abu wazaneh': 'Yousef Abu Wazaneh.png',
  };

  /// Get the asset path for a player photo
  /// Returns null if player photo doesn't exist
  static String? getPlayerPhotoPath(String playerName) {
    if (playerName.isEmpty) return null;

    final normalizedName = playerName.toLowerCase().trim();

    // DEBUG: Print what we're looking for
    print('🔍 PlayerPhotoHelper DEBUG:');
    print('   Original name: "$playerName"');
    print('   Normalized: "$normalizedName"');

    // Try exact mapping first
    if (_playerPhotoMap.containsKey(normalizedName)) {
      final path = 'assets/images/players/${_playerPhotoMap[normalizedName]}';
      print('   ✅ Found in mapping: $path');
      return path;
    }

    // Try converting name to standard format
    final fileName = _convertNameToFileName(playerName);
    final path = 'assets/images/players/$fileName';
    print('   📝 Trying title case: $path');
    return path;
  }

  /// Convert player name to file name format
  /// Handles both lowercase and title case files
  static String _convertNameToFileName(String name) {
    // First, try with proper capitalization (matching your files)
    final words = name.trim().split(' ');
    final titleCase = words.map((word) {
      if (word.isEmpty) return word;
      // Handle "Al-", "Abu", etc.
      if (word.toLowerCase().startsWith('al-') ||
          word.toLowerCase().startsWith('abu')) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      // Capitalize first letter of each word
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return '$titleCase.png';
  }

  /// Get player avatar color based on sport
  static Color getPlayerColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'basketball':
        return const Color(0xFFF59E0B);
      case 'football':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFFDC2626);
    }
  }

  /// Get player initials from name
  static String getPlayerInitials(String playerName) {
    if (playerName.isEmpty) return '??';

    final words = playerName.trim().split(' ');

    if (words.length >= 2) {
      return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
    } else if (playerName.length >= 2) {
      return playerName.substring(0, 2).toUpperCase();
    } else {
      return playerName.substring(0, 1).toUpperCase();
    }
  }

  /// Build player photo widget with fallback
  static Widget buildPlayerPhoto({
    required String playerName,
    required double size,
    required String sport,
    bool showBorder = true,
  }) {
    final photoPath = getPlayerPhotoPath(playerName);
    final sportColor = getPlayerColor(sport);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: sportColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
          color: sportColor.withOpacity(0.3),
          width: 2,
        )
            : null,
      ),
      child: ClipOval(
        child: photoPath != null
            ? Image.asset(
          photoPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // DEBUG: Print error
            print('   ❌ Image load ERROR: $error');
            // Fallback to initials if image fails to load
            return _buildInitialsAvatar(
              playerName,
              size,
              sportColor,
            );
          },
        )
            : _buildInitialsAvatar(
          playerName,
          size,
          sportColor,
        ),
      ),
    );
  }

  /// Build player photo widget for hero header (larger, with gradient)
  static Widget buildPlayerHeroPhoto({
    required String playerName,
    required double size,
    required String sport,
  }) {
    final photoPath = getPlayerPhotoPath(playerName);
    final sportColor = getPlayerColor(sport);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            sportColor.withOpacity(0.3),
            sportColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: sportColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: photoPath != null
            ? Image.asset(
          photoPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('   ❌ Hero image load ERROR: $error');
            return Center(
              child: Icon(
                sport == 'basketball'
                    ? Icons.sports_basketball
                    : Icons.sports_soccer,
                size: size * 0.5,
                color: Colors.white,
              ),
            );
          },
        )
            : Center(
          child: Icon(
            sport == 'basketball'
                ? Icons.sports_basketball
                : Icons.sports_soccer,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Build initials-based avatar (fallback)
  static Widget _buildInitialsAvatar(
      String playerName,
      double size,
      Color color,
      ) {
    final initials = getPlayerInitials(playerName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }

  /// Build player card photo (smaller, with status indicator)
  static Widget buildPlayerCardPhoto({
    required String playerName,
    required double size,
    required String sport,
    bool isPro = false,
    bool isActive = true,
  }) {
    final sportColor = getPlayerColor(sport);

    final Color statusColor = isPro
        ? const Color(0xFF10B981)
        : isActive
        ? const Color(0xFFF59E0B)
        : const Color(0xFFDC2626);

    return Stack(
      children: [
        buildPlayerPhoto(
          playerName: playerName,
          size: size,
          sport: sport,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size * 0.25,
            height: size * 0.25,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1A1D1F),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Get expected file name for a player (for debugging)
  static String getExpectedFileName(String playerName) {
    return _convertNameToFileName(playerName);
  }
}