import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluuterek/controllers/auth_controller.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../widgets/common/main_button.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: mainGradient(),
        ), // BoxDecoration
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app_splash_logo.png", width: 200, height: 200,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: const Text(
                  "This is a study app. You can use as you want. You have the full access to all the matierials in this course",
                      style: TextStyle(
                        color: onSurfaceTextColor, fontWeight: FontWeight.bold
              ),
                textAlign: TextAlign.center,
              ),
            ), // Text
            MainButton(
              onTap: (){
                controller.signInWithGoogle();
            },
              child: Stack(
                children: [
                  Positioned(
                    top:0,
                      bottom:0,
                      left: 0,

                      child: SvgPicture.asset("assets/icons/google.svg")),
                  Center(
                    child: Text(
                      "Sign in with Google",
                      style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ],
            ),
            ),
          ],
        ), // Column
      ), // Container
    ); // Scaffold
  }
}
