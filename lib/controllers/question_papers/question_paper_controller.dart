import 'package:fluuterek/firebase_ref/references.dart';
import 'package:fluuterek/models/question_paper_model.dart';
import 'package:fluuterek/screens/question/questions_screen.dart';
import 'package:fluuterek/services/firebase_storage_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_controller.dart';

class QuizPaperController extends GetxController {
  final allPaperImages = <String>[].obs;
  final allPapers = <QuestionPaperModel>[].obs;

  @override
  void onReady() {
    getAllPapers();
    super.onReady();
  }

  Future<void> getAllPapers() async {
    List<String> imgName = ["bialogy", "chemistry", "maths", "physics"];
    try {
      QuerySnapshot<Map<String, dynamic>> data = await questionPaperRF.get();
      final paperList = data.docs
          .map((paper) => QuestionPaperModel.fromSnapshot(paper))
          .toList();
      allPapers.assignAll(paperList);

      for (var paper in paperList) {
        final imgUrl = await Get.find<FirebaseStorageService>().getImage(
            paper.title);
        paper.imageUrl = imgUrl;
      }
      allPapers.assignAll(paperList);
    } catch (e) {
      print(e);
    }
  }

  void navigateToQuestions({required QuestionPaperModel paper, bool tryAgain = false}) {
    AuthController authController = Get.find();
    if (authController.isLoggedIn()) {
      if (tryAgain) {
        Get.back();

        Get.toNamed(
          QuestionsScreen.routeName,
          arguments: paper,
          preventDuplicates: false,
        );

      } else {
          Get.toNamed(QuestionsScreen.routeName, arguments: paper);
      }
    } else {

      authController.showLoginAlertDialogue();
    }
  }
}