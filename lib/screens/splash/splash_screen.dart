import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: mainGradient(), // Gradient na całym ekranie
        ),
        child: Center( // Umieszcza obraz na środku
          child: Image.asset(
            "assets/images/app_splash_logo.png",
            width: 200, // Rozmiar obrazu
            height: 200,
          ),
        ),
      ),
    );
  }
}
