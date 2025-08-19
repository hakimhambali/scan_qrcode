import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  Widget nextScreen;
  LoadingScreen(this.nextScreen, {super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/loading.json'),
      backgroundColor: Colors.purple.shade50,
      nextScreen: widget.nextScreen,
      splashIconSize: 500,
      duration: 1,
    );
  }
}
