import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/app_colors.dart';
import 'package:get/get.dart';
import '../../widgets/app_circle_button.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient()),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 65,
              ),
              const SizedBox(height: 20),
              const Text(
                'This is a study app. You can use it as you want. If you understand how this works you would be able to scale it. With this you will master firebase backend and flutter frontend',
                style: TextStyle(
                  fontSize: 18,
                  color: onSurfaceTextColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            AppCircleButton(
              onTap: () {
                print('Navigating to details...');
                Get.toNamed('/home');
              },
              child: const Icon(Icons.arrow_forward, size: 35),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
