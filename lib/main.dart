import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const JoSportApp());
}

class JoSportApp extends StatelessWidget {
  const JoSportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JoSport - Where Jordan Plays',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(), // Start with splash screen
    );
  }
}