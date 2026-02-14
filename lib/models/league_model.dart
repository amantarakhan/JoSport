import 'package:cloud_firestore/cloud_firestore.dart';

class LeagueModel {
  final String leagueName;
  final List<StandingItem> standings;
  final DateTime lastUpdated;

  LeagueModel({
    required this.leagueName,
    required this.standings,
    required this.lastUpdated,
  });

  factory LeagueModel.fromFirestore(Map<String, dynamic> data) {
    final standingsData = data['standings'] as List<dynamic>? ?? [];

    final standings = standingsData.map((item) {
      return StandingItem.fromMap(item as Map<String, dynamic>);
    }).toList();

    // Handle both Timestamp and String formats
    DateTime parsedDate;
    final lastUpdatedField = data['last_updated'];

    if (lastUpdatedField is Timestamp) {
      parsedDate = lastUpdatedField.toDate();
    } else if (lastUpdatedField is String) {
      parsedDate = DateTime.parse(lastUpdatedField);
    } else {
      parsedDate = DateTime.now();
    }

    return LeagueModel(
      leagueName: data['league_name'] ?? '',
      standings: standings,
      lastUpdated: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_name': leagueName,
      'standings': standings.map((s) => s.toMap()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class StandingItem {
  final String team;
  final int matchesPlayed;
  final int points;
  final int rank;

  StandingItem({
    required this.team,
    required this.matchesPlayed,
    required this.points,
    required this.rank,
  });

  factory StandingItem.fromMap(Map<String, dynamic> map) {
    return StandingItem(
      team: map['team'] ?? '',
      matchesPlayed: int.tryParse(map['mp']?.toString() ?? '0') ?? 0,
      points: int.tryParse(map['pts']?.toString() ?? '0') ?? 0,
      rank: int.tryParse(map['rank']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team': team,
      'mp': matchesPlayed.toString(),
      'pts': points.toString(),
      'rank': rank.toString(),
    };
  }
}