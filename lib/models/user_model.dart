class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final List<String>? followedTeams;
  final bool isProMember;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.followedTeams,
    this.isProMember = false,
  });

  // Create UserModel from Firebase User
  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'followedTeams': followedTeams ?? [],
      'isProMember': isProMember,
    };
  }

  // Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      followedTeams: json['followedTeams'] != null
          ? List<String>.from(json['followedTeams'])
          : null,
      isProMember: json['isProMember'] ?? false,
    );
  }

  // Copy with method for updating user data
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? followedTeams,
    bool? isProMember,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      followedTeams: followedTeams ?? this.followedTeams,
      isProMember: isProMember ?? this.isProMember,
    );
  }
}