import 'package:fluuterek/controllers/zoom_drawes_controller.dart';
import 'package:fluuterek/screens/introduction/introduction.dart';
import 'package:fluuterek/screens/question/questions_screen.dart';
import 'package:fluuterek/screens/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:fluuterek/screens/home/home_screen.dart';
import 'package:fluuterek/controllers/question_papers/question_paper_controller.dart';

import '../controllers/question_papers/questions_controller.dart';
import '../screens/login/login_screen.dart';
import '../screens/question/answer_check_screen.dart';
import '../screens/question/result_screen.dart';
import '../screens/question/test_overview_screen.dart';
class AppRoutes {
  static List<GetPage> routes() => [
    GetPage(
      name: "/",
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: "/introduction",
      page: () => const AppIntroductionScreen(),
    ),
    GetPage(
      name: "/home",
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(QuizPaperController());
        Get.put(MyZoomDrawerController());
      }),
    ),
    GetPage(
      name: LoginScreen.routeName,
      page: ()=>LoginScreen()
    ),
    GetPage(
        name: QuestionsScreen.routeName,
        page: ()=>QuestionsScreen(),
      binding:BindingsBuilder((){
        Get.put<QuestionsController>(QuestionsController());

    })
    ),

    GetPage(
      name: TestOverviewScreen.routeName,
      page: () => const TestOverviewScreen(),
    ),
    GetPage(
      name: ResultScreen.routeName,
      page: () => const ResultScreen(),
    ),
    GetPage(
      name: AnswerCheckScreen.routeName,
      page: () => const AnswerCheckScreen(),
    ), // GetPage

  ];

}
