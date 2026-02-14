import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/team_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  List<TeamModel> _followedTeams = [];
  bool _matchNotifications = true;
  bool _sportMode = true;
  String _sportTheme = 'Mixed';

  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<TeamModel> get followedTeams => _followedTeams;
  bool get matchNotifications => _matchNotifications;
  bool get sportMode => _sportMode;
  String get sportTheme => _sportTheme;
  bool get isLoading => _isLoading;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
    _loadUserData();
  }

  /// Create or update user document in Firestore
  /// Called when user logs in for the first time or returns
  Future<void> createOrUpdateUserDocument() async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final userRef = _firestore.collection('users').doc(_currentUser!.uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        // First time user - create new document with defaults
        await userRef.set({
          'uid': _currentUser!.uid,
          'email': _currentUser!.email,
          'displayName': _currentUser!.displayName,
          'photoUrl': _currentUser!.photoUrl,
          'followedTeams': [],
          'matchNotifications': true,
          'sportMode': true,
          'sportTheme': 'Mixed',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

        // Set local defaults
        _followedTeams = [];
        _matchNotifications = true;
        _sportMode = true;
        _sportTheme = 'Mixed';
      } else {
        // Existing user - update last login and load data
        await userRef.update({
          'lastLoginAt': FieldValue.serverTimestamp(),
          // Also update profile info in case it changed (e.g., Google name/photo)
          'email': _currentUser!.email,
          'displayName': _currentUser!.displayName,
          'photoUrl': _currentUser!.photoUrl,
        });

        // Load existing user data
        await _loadUserData();
      }
    } catch (e) {
      debugPrint('Error creating/updating user document: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        // followedTeams stored as list of Team json objects
        if (data['followedTeams'] != null) {
          _followedTeams = (data['followedTeams'] as List)
              .map((team) => TeamModel.fromJson(team))
              .toList();
        }

        _matchNotifications = data['matchNotifications'] ?? true;
        _sportMode = data['sportMode'] ?? true;
        _sportTheme = data['sportTheme'] ?? 'Mixed';
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      if (updates.isEmpty) return;

      await _firestore.collection('users').doc(_currentUser!.uid).update(updates);

      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleMatchNotifications(bool value) async {
    if (_currentUser == null) return;

    final old = _matchNotifications;
    _matchNotifications = value;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'matchNotifications': value,
      });
    } catch (e) {
      debugPrint('Error updating notifications: $e');
      _matchNotifications = old;
      notifyListeners();
    }
  }

  Future<void> toggleSportMode(bool value) async {
    if (_currentUser == null) return;

    final old = _sportMode;
    _sportMode = value;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'sportMode': value,
      });
    } catch (e) {
      debugPrint('Error updating sport mode: $e');
      _sportMode = old;
      notifyListeners();
    }
  }

  Future<void> updateSportTheme(String theme) async {
    if (_currentUser == null) return;

    final old = _sportTheme;
    _sportTheme = theme;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'sportTheme': theme,
      });
    } catch (e) {
      debugPrint('Error updating sport theme: $e');
      _sportTheme = old;
      notifyListeners();
    }
  }

  Future<void> addFollowedTeam(TeamModel team) async {
    if (_currentUser == null) return;

    _followedTeams.add(team);
    notifyListeners();

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'followedTeams': _followedTeams.map((t) => t.toJson()).toList(),
      });
    } catch (e) {
      debugPrint('Error adding team: $e');
      _followedTeams.remove(team);
      notifyListeners();
    }
  }

  Future<void> removeFollowedTeam(String teamId) async {
    if (_currentUser == null) return;

    _followedTeams.removeWhere((t) => t.id == teamId);
    notifyListeners();

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'followedTeams': _followedTeams.map((t) => t.toJson()).toList(),
      });
    } catch (e) {
      debugPrint('Error removing team: $e');
      _loadUserData();
    }
  }

  void clearUser() {
    _currentUser = null;
    _followedTeams = [];
    _matchNotifications = true;
    _sportMode = true;
    _sportTheme = 'Mixed';
    notifyListeners();
  }
}