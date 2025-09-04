import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluuterek/bindings/inital_bindings.dart';
import 'package:fluuterek/controllers/theme_controller.dart';
import 'package:fluuterek/routes/app_routes.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  InitialBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeController.isDarkMode.value
            ? themeController.darkTheme
            : themeController.lightTheme,
        getPages: AppRoutes.routes(),
        initialRoute: '/',
      );
    });
  }
}
