import 'package:flutter/material.dart';

/// Team Logo Helper
/// Maps team names to their logo asset paths
/// Handles variations in team names and provides fallback colors
class TeamLogoHelper {
  // Map of team names to their logo file names
  static final Map<String, String> _teamLogoMap = {
    // ========== FOOTBALL TEAMS (from Firebase) ==========
    'al ramtha': 'Al-Ramtha SC.png',
    'al hussein': 'Al-Hussein SC (Irbid).png',
    'al-faisaly amman': 'Al-Faisaly.png',
    'al wehdat': 'Al-Wehdat.png',
    'al salt': 'Al-Salt.png',
    'al buqaa': 'Al-Baqa\'a.png',
    'al jazeera amman': 'Al-Jazeera.png',
    'shabab al ordon': 'Shabab Al-Ordon.png',
    'al ahli': 'Ahli.png',
    'sama al sarhan': 'Moghayer Al-Sarhan.png', // Sama = Moghayer?

    // ========== BASKETBALL TEAMS (from Firebase) ==========
    'amman united': 'Amman United.png',
    'al faisaly': 'Al-Faisaly.png',
    'al jubaiha': 'Jubiha.png',
    'al wehdat amman': 'Al-Wehdat.png',
    'al ingliziya': 'Inglizia.png',
    'al jalil irbid': 'Jaleel.png',
    'ashrafieh': 'Ashrafieh.png',
    'shabab bushra': 'Shabab Bushra.png',

    // ========== ALTERNATIVE SPELLINGS ==========
    // Hyphenated versions
    'al-ramtha': 'Al-Ramtha SC.png',
    'al-ramtha sc': 'Al-Ramtha SC.png',
    'al-hussein': 'Al-Hussein SC (Irbid).png',
    'al-hussein sc (irbid)': 'Al-Hussein SC (Irbid).png',
    'al-hussein irbid': 'Al-Hussein SC (Irbid).png',
    'al-faisaly': 'Al-Faisaly.png',
    'al-wehdat': 'Al-Wehdat.png',
    'al-salt': 'Al-Salt.png',
    'al-jazeera': 'Al-Jazeera.png',
    'al-buqaa': 'Al-Baqa\'a.png',
    'al-baqa\'a': 'Al-Baqa\'a.png',
    'al-baqaa': 'Al-Baqa\'a.png',

    // Without "Al" prefix
    'ramtha': 'Al-Ramtha SC.png',
    'hussein': 'Al-Hussein SC (Irbid).png',
    'faisaly': 'Al-Faisaly.png',
    'wehdat': 'Al-Wehdat.png',
    'salt': 'Al-Salt.png',
    'jazeera': 'Al-Jazeera.png',
    'buqaa': 'Al-Baqa\'a.png',
    'ahli': 'Ahli.png',

    // Variations
    'jubaiha': 'Jubiha.png',
    'jubiha': 'Jubiha.png',
    'ingliziya': 'Inglizia.png',
    'inglizia': 'Inglizia.png',
    'jalil': 'Jaleel.png',
    'jaleel': 'Jaleel.png',
    'moghayer al-sarhan': 'Moghayer Al-Sarhan.png',
    'moghayer al sarhan': 'Moghayer Al-Sarhan.png',

    // Old variations
    'that ras': 'Al-Ramtha SC.png',
  };

  /// Get the asset path for a team logo
  /// Returns null if team logo doesn't exist
  static String? getTeamLogoPath(String teamName) {
    // Normalize: lowercase, trim, remove extra spaces
    final normalizedName = teamName.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

    // Try exact match first
    if (_teamLogoMap.containsKey(normalizedName)) {
      return 'assets/images/clubs/${_teamLogoMap[normalizedName]}';
    }

    // Try without spaces/hyphens
    final noSpaces = normalizedName.replaceAll(' ', '').replaceAll('-', '');
    for (var entry in _teamLogoMap.entries) {
      final keyNoSpaces = entry.key.replaceAll(' ', '').replaceAll('-', '');
      if (noSpaces == keyNoSpaces) {
        return 'assets/images/clubs/${entry.value}';
      }
    }

    // Try partial match (contains)
    for (var entry in _teamLogoMap.entries) {
      if (normalizedName.contains(entry.key) || entry.key.contains(normalizedName)) {
        return 'assets/images/clubs/${entry.value}';
      }
    }

    // Try removing common suffixes
    final withoutSuffixes = normalizedName
        .replaceAll(' amman', '')
        .replaceAll(' sc', '')
        .replaceAll(' (irbid)', '');

    if (_teamLogoMap.containsKey(withoutSuffixes)) {
      return 'assets/images/clubs/${_teamLogoMap[withoutSuffixes]}';
    }

    return null;
  }

  /// Get team color based on name (fallback when logo doesn't exist)
  static Color getTeamColor(String teamName) {
    final normalizedName = teamName.toLowerCase().trim();

    // Define specific colors for known teams
    final Map<String, Color> teamColors = {
      'al-wehdat': const Color(0xFF10B981),
      'al-faisaly': const Color(0xFF3B82F6),
      'al-ramtha': const Color(0xFFEF4444),
      'al-jazeera': const Color(0xFFF59E0B),
      'al-salt': const Color(0xFF8B5CF6),
      'shabab al-ordon': const Color(0xFFEC4899),
      'al-hussein irbid': const Color(0xFF14B8A6),
      'that ras': const Color(0xFF6366F1),
    };

    // Try to find color for team
    for (var entry in teamColors.entries) {
      if (normalizedName.contains(entry.key)) {
        return entry.value;
      }
    }

    // Generate color from team name hash
    final hash = teamName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
  }

  /// Get team initials
  static String getTeamInitials(String teamName) {
    final words = teamName.split(' ');

    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (teamName.length >= 2) {
      return teamName.substring(0, 2).toUpperCase();
    } else {
      return teamName.substring(0, 1).toUpperCase();
    }
  }

  /// Build team logo widget with fallback
  static Widget buildTeamLogo({
    required String teamName,
    required double size,
    Color? fallbackColor,
  }) {
    final logoPath = getTeamLogoPath(teamName);

    if (logoPath != null) {
      // Show actual logo
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.25), // 25% of size for rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.25),
          child: Image.asset(
            logoPath,
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to initials if image fails to load
              return _buildInitialsLogo(teamName, size, fallbackColor);
            },
          ),
        ),
      );
    } else {
      // Fallback to initials
      return _buildInitialsLogo(teamName, size, fallbackColor);
    }
  }

  /// Build initials-based logo (fallback)
  static Widget _buildInitialsLogo(String teamName, double size, Color? fallbackColor) {
    final color = fallbackColor ?? getTeamColor(teamName);
    final initials = getTeamInitials(teamName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: size * 0.35, // 35% of size
          ),
        ),
      ),
    );
  }
}