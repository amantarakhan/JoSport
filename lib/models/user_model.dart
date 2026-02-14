import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;

  /// We store it as `photoUrl` in our model + firestore
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

  /// ✅ Compatibility getter in case any code uses photoURL naming
  String? get photoURL => photoUrl;

  /// ✅ Works if you pass Firebase User OR already a UserModel
  factory UserModel.fromFirebaseUser(dynamic u) {
    if (u is UserModel) return u;

    if (u is User) {
      return UserModel(
        uid: u.uid,
        email: u.email ?? '',
        displayName: u.displayName,
        photoUrl: u.photoURL,
      );
    }

    throw ArgumentError('Unsupported user type: ${u.runtimeType}');
  }

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['uid'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      followedTeams: (json['followedTeams'] as List?)?.map((e) => e.toString()).toList(),
      isProMember: (json['isProMember'] ?? false) as bool,
    );
  }

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
