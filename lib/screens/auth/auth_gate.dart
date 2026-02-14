import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart' as auth_prov;
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../config/theme/app_colors.dart';
import 'login_screen.dart';
import '../main_navigation_screen.dart';

/// AuthGate Widget
///
/// This widget listens to Firebase auth state changes and:
/// - Shows loading screen while checking auth status
/// - Redirects to LoginScreen if user is NOT authenticated
/// - Redirects to MainNavigationScreen if user IS authenticated
/// - Syncs user data with Firestore on login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.courtOrange,
              ),
            ),
          );
        }

        // Check if user is logged in
        final User? firebaseUser = snapshot.data;

        if (firebaseUser == null) {
          // User is NOT logged in - show login screen
          return const LoginScreen();
        } else {
          // User IS logged in - sync data and show home
          return _AuthenticatedWrapper(firebaseUser: firebaseUser);
        }
      },
    );
  }
}

/// Private wrapper that handles user data synchronization
class _AuthenticatedWrapper extends StatefulWidget {
  final User firebaseUser;

  const _AuthenticatedWrapper({required this.firebaseUser});

  @override
  State<_AuthenticatedWrapper> createState() => _AuthenticatedWrapperState();
}

class _AuthenticatedWrapperState extends State<_AuthenticatedWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    if (_isInitialized) return;

    final authProvider = Provider.of<auth_prov.AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Create UserModel from Firebase User
    final userModel = UserModel.fromFirebaseUser(widget.firebaseUser);

    // Set user in providers
    userProvider.setUser(userModel);

    // Create/update user document in Firestore
    await userProvider.createOrUpdateUserDocument();

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.courtOrange,
          ),
        ),
      );
    }

    return const MainNavigationScreen();
  }
}