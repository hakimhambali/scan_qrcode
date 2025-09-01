import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigation_wrapper.dart';
import 'configs/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppThemes.blueGradientTheme,
    home: const NavigationWrapper(initialIndex: 0),
  ));
}

