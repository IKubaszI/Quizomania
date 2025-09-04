import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';
import 'package:fluuterek/configs/themes/app_colors.dart';
import 'package:fluuterek/configs/themes/app_icons.dart';
import 'package:fluuterek/configs/themes/custom_text_styles.dart';
import 'package:fluuterek/configs/themes/ui_parameters.dart';
import 'package:fluuterek/controllers/theme_controller.dart';
import 'package:fluuterek/controllers/zoom_drawes_controller.dart';
import 'package:fluuterek/screens/home/menu_screen.dart';
import 'package:fluuterek/screens/home/question_card.dart';
import 'package:fluuterek/widgets/app_circle_button.dart';
import 'package:fluuterek/widgets/content_area.dart';
import 'package:get/get.dart';

import '../../controllers/question_papers/question_paper_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int shakeCount = 0;
  bool isCooldown = false;
  double shakeThreshold = 45.0;
  Timer? shakeCooldownTimer;
  final Random random = Random();
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late Timer _clockTimer;
  String currentTime = "0:00:00";

  @override
  void initState() {
    super.initState();
    startShakeDetection();
    startClock();
  }

  Future<void> startClock() async {
    final prefs = await SharedPreferences.getInstance();
    final lastQuizTime = prefs.getString('lastQuizTime');

    if (lastQuizTime != null) {
      final lastQuizDateTime = DateTime.parse(lastQuizTime);
      updateClock(lastQuizDateTime);
    } else {
      debugPrint('Brak danych o ostatnim quizie.');
      currentTime = "0:00:00";
    }

    // Rozpocznij odliczanie
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (lastQuizTime != null) {
        final lastQuizDateTime = DateTime.parse(lastQuizTime);
        updateClock(lastQuizDateTime);
      }
    });
  }

  void updateClock(DateTime lastQuizTime) {
    final now = DateTime.now();
    final duration = now.difference(lastQuizTime);

    setState(() {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      currentTime = "$hours:$minutes:$seconds";
    });
  }

  void startShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      detectShake(event);
    });
  }

  void stopShakeDetection() {
    _accelerometerSubscription.cancel();
  }

  void detectShake(AccelerometerEvent event) {
    final double acceleration =
    sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if (acceleration > shakeThreshold && !isCooldown) {
      setState(() {
        shakeCount++;
      });
      debugPrint('Liczba potrząśnięć: $shakeCount');
      triggerVibration();
      chooseRandomCourse();
      startCooldown();
    }
  }

  void triggerVibration() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 500, amplitude: 255);
        debugPrint('Vibration Activate.');
      } else {
        debugPrint('Urządzenie nie obsługuje wibracji.');
      }
    } catch (e) {
      debugPrint('Błąd podczas uruchamiania wibracji: $e');
    }
  }

  void chooseRandomCourse() {
    final QuizPaperController questionPaperController = Get.find();

    if (questionPaperController.allPapers.isNotEmpty) {
      final int randomIndex =
      random.nextInt(questionPaperController.allPapers.length);
      final selectedCourse = questionPaperController.allPapers[randomIndex];
      debugPrint('Wybrano losowy kurs: ${selectedCourse.title}');
      questionPaperController.navigateToQuestions(paper: selectedCourse);
    } else {
      debugPrint('Brak dostępnych kursów.');
    }
  }

  void startCooldown() {
    isCooldown = true;
    shakeCooldownTimer?.cancel();
    shakeCooldownTimer = Timer(const Duration(seconds: 2), () {
      isCooldown = false;
    });
  }

  @override
  void dispose() {
    stopShakeDetection();
    shakeCooldownTimer?.cancel();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final MyZoomDrawerController drawerController = Get.find();
    final QuizPaperController questionPaperController = Get.find();

    return Scaffold(
      body: GetBuilder<MyZoomDrawerController>(
        builder: (_) {
          return ZoomDrawer(
            borderRadius: 50.0,
            controller: _.zoomDrawerController,
            showShadow: true,
            angle: 0.0,
            style: DrawerStyle.DefaultStyle,
            backgroundColor: Colors.white.withOpacity(0.5),
            slideWidth: MediaQuery.of(context).size.width * 0.4,
            menuScreen: MyMenuScreen(),
            mainScreen: Container(
              decoration: BoxDecoration(gradient: mainGradient()),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(mobileScreenPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppCircleButton(
                            child: const Icon(AppIcons.menuLeft),
                            onTap: drawerController.toggleDrawer,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Last Quiz",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                currentTime,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: themeController.isDarkMode.value
                                      ? Colors.yellow
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            return IconButton(
                              icon: Icon(
                                themeController.isDarkMode.value
                                    ? Icons.nightlight_round
                                    : Icons.wb_sunny,
                                color: themeController.isDarkMode.value
                                    ? Colors.yellow
                                    : Colors.white,
                              ),
                              onPressed: () {
                                themeController.toggleTheme(
                                    !themeController.isDarkMode.value);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(mobileScreenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(AppIcons.peace, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                "Hello friend",
                                style: detailText.copyWith(
                                  color: onSurfaceTextColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "What do you want to learn today?",
                            style: headerText,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ContentArea(
                          addPadding: false,
                          child: Obx(
                                () => ListView.separated(
                              padding: UIParameters.mobileScreenPadding,
                              itemBuilder: (context, index) {
                                return QuestionCard(
                                  model: questionPaperController.allPapers[index],
                                );
                              },
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                              itemCount:
                              questionPaperController.allPapers.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
