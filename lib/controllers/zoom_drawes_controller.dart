import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluuterek/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyZoomDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  Rxn<User?> user = Rxn();
  @override
  void onReady(){
    user.value = Get.find<AuthController>().getUser();
    super.onReady();
  }


  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }
  void signOut() {
    Get.find<AuthController>().signOut();
  }

  void signIn() {
    // Dodaj logikę logowania
  }



  void website() {
    _launch("https://www.dbestech.com");
    }


  void facebook() {
    _launch("https://www.facebook.com");
  }

  void email() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@dbestech.com',
    );

    _launch(emailLaunchUri.toString());
}
    Future<void> _launch(String url) async {
      if (!await launch(url)) {
        throw 'Could not launch $url';
      }
    }


  }

