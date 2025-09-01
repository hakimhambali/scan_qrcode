import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigation_wrapper.dart';
// import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    // themeMode: ThemeMode.system,
    // theme: MyThemes.lightTheme,
    // darkTheme: MyThemes.darkTheme,
    home: NavigationWrapper(initialIndex: 0),
  ));
}

