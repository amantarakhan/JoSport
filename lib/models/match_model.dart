import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String home;
  final String away;
  final String homeScore;
  final String awayScore;
  final String sport;
  final String status;
  final String time;
  final String? homeTeamLogo;
  final String? awayTeamLogo;

  MatchModel({
    required this.id,
    required this.home,
    required this.away,
    required this.homeScore,
    required this.awayScore,
    required this.sport,
    required this.status,
    required this.time,
    this.homeTeamLogo,
    this.awayTeamLogo,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MatchModel(
      id: doc.id,
      home: data['home'] ?? '',
      away: data['away'] ?? '',
      homeScore: data['homeScore']?.toString() ?? '0',
      awayScore: data['awayScore']?.toString() ?? '0',
      sport: data['sport'] ?? '',
      status: data['status'] ?? '',
      time: data['time'] ?? '',
      homeTeamLogo: data['homeTeamLogo'],
      awayTeamLogo: data['awayTeamLogo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'away': away,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'sport': sport,
      'status': status,
      'time': time,
      'homeTeamLogo': homeTeamLogo,
      'awayTeamLogo': awayTeamLogo,
    };
  }

  // Helper to check if match is live
  bool get isLive => status.toLowerCase() == 'live';

  // Helper to check if match is finished
  bool get isFinished => status.toLowerCase() == 'finished';

  // Helper to check if match is upcoming
  bool get isUpcoming => status.toLowerCase() == 'upcoming' ||
      status.toLowerCase() == 'scheduled';

  // Helper to check if match is football
  bool get isFootball => sport.toLowerCase() == 'football' ||
      sport.toLowerCase() == 'soccer';

  // Helper to check if match is basketball
  bool get isBasketball => sport.toLowerCase() == 'basketball';

  // Get league name from sport
  String get league {
    if (isFootball) return 'Jordanian Pro League';
    if (isBasketball) return 'Jordan Basketball League';
    return sport;
  }

  // Get minute/time display
  String get minute {
    if (isLive) {
      // Extract minute from time if it's in format like "72'"
      if (time.contains("'")) return time;
      if (time.toLowerCase().startsWith('q')) return time; // Quarter format
      return 'LIVE';
    }
    return time;
  }

  // Get league color
  String get leagueColor {
    if (isFootball) return '#10B981'; // Green
    if (isBasketball) return '#F97316'; // Orange
    return '#EF4444'; // Red default
  }

  // Get scheduled time for upcoming matches
  DateTime? get scheduledTime {
    if (!isUpcoming) return null;

    try {
      // Parse time format "21.12. 20:30"
      final parts = time.split(' ');
      if (parts.length != 2) return null;

      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');

      if (dateParts.length < 2 || timeParts.length != 2) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = DateTime.now().year; // Assume current year
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}