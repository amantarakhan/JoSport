import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/team_model.dart';

/// FirestoreService
///
/// Helper service for Firestore database operations
/// Provides methods for user data management
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String usersCollection = 'users';
  static const String teamsCollection = 'teams';

  /// Get user document reference
  DocumentReference<Map<String, dynamic>> getUserRef(String uid) {
    return _firestore.collection(usersCollection).doc(uid);
  }

  /// Create a new user document
  Future<void> createUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await getUserRef(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName ?? '',
        'photoUrl': photoUrl ?? '',
        'followedTeams': [],
        'matchNotifications': true,
        'sportMode': true,
        'sportTheme': 'Mixed',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await getUserRef(uid).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      if (updates.isNotEmpty) {
        await getUserRef(uid).update(updates);
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Update followed teams
  Future<void> updateFollowedTeams({
    required String uid,
    required List<TeamModel> teams,
  }) async {
    try {
      await getUserRef(uid).update({
        'followedTeams': teams.map((t) => t.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Failed to update teams: $e');
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings({
    required String uid,
    required bool enabled,
  }) async {
    try {
      await getUserRef(uid).update({
        'matchNotifications': enabled,
      });
    } catch (e) {
      throw Exception('Failed to update notifications: $e');
    }
  }

  /// Update sport mode
  Future<void> updateSportMode({
    required String uid,
    required bool enabled,
  }) async {
    try {
      await getUserRef(uid).update({
        'sportMode': enabled,
      });
    } catch (e) {
      throw Exception('Failed to update sport mode: $e');
    }
  }

  /// Update sport theme
  Future<void> updateSportTheme({
    required String uid,
    required String theme,
  }) async {
    try {
      await getUserRef(uid).update({
        'sportTheme': theme,
      });
    } catch (e) {
      throw Exception('Failed to update sport theme: $e');
    }
  }

  /// Update last login timestamp
  Future<void> updateLastLogin(String uid) async {
    try {
      await getUserRef(uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update last login: $e');
    }
  }

  /// Delete user document
  Future<void> deleteUser(String uid) async {
    try {
      await getUserRef(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Stream user data (real-time updates)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData(String uid) {
    return getUserRef(uid).snapshots();
  }

  /// Check if user document exists
  Future<bool> userExists(String uid) async {
    try {
      final doc = await getUserRef(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}