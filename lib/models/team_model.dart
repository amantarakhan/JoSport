class TeamModel {
  final String id;
  final String name;
  final String colorHex; // For the circular background color

  TeamModel({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
    };
  }

  // Create from Firestore document
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      colorHex: json['colorHex'] ?? '#10B981',
    );
  }

  TeamModel copyWith({
    String? id,
    String? name,
    String? colorHex,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}