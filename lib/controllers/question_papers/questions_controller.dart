import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:fluuterek/controllers/question_papers/question_paper_controller.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../../firebase_ref/loading_status.dart';
import '../../firebase_ref/references.dart';
import '../../models/question_paper_model.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/question/result_screen.dart';

class QuestionsController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  late QuestionPaperModel questionPaperModel;
  final allQuestions = <Questions>[];
  final questionIndex = 0.obs;
  Rxn<Questions> currentQuestion = Rxn<Questions>();

  bool get isFirstQuestion => questionIndex.value > 0;
  bool get isLastQuestion => questionIndex.value >= allQuestions.length - 1;

  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;

  @override
  void onReady() {
    final _questionPaper = Get.arguments as QuestionPaperModel;
    loadData(_questionPaper);
    super.onReady();
  }

  Future<void> loadData(QuestionPaperModel questionPaper) async {
    questionPaperModel = questionPaper;
    loadingStatus.value = LoadingStatus.loading;

    try {
      final QuerySnapshot<Map<String, dynamic>> questionQuery =
      await questionPaperRF.doc(questionPaper.id).collection("questions").get();
      final questions = questionQuery.docs
          .map((snapshot) => Questions.fromSnapshot(snapshot))
          .toList();

      questionPaper.questions = questions;

      for (Questions _question in questionPaper.questions!) {
        final QuerySnapshot<Map<String, dynamic>> answersQuery =
        await questionPaperRF
            .doc(questionPaper.id)
            .collection("questions")
            .doc(_question.id)
            .collection("answers")
            .get();

        final answers = answersQuery.docs
            .map((answer) => Answers.fromSnapshot(answer.data()))
            .toList();

        _question.answers = answers;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (questionPaper.questions != null && questionPaper.questions!.isNotEmpty) {
      allQuestions.assignAll(questionPaper.questions!);
      currentQuestion.value = questionPaper.questions![0];
      _startTimer(questionPaper.timeSeconds);
      loadingStatus.value = LoadingStatus.completed;
    } else {
      loadingStatus.value = LoadingStatus.error;
    }
  }

  void selectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    update(['answers_list']); // Notify changes
  }

  String get completedTest {
    final answered = allQuestions
        .where((element) => element.selectedAnswer != null)
        .toList()
        .length;
    return '$answered out of ${allQuestions.length} answered';
  }

  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = allQuestions[index];
    if (isGoBack) {
      Get.back();
    }
  }

  void nextQuestion() {
    if (questionIndex.value >= allQuestions.length - 1) {
      return;
    }
    questionIndex.value++;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  void prevQuestion() {
    if (questionIndex.value <= 0) return;
    questionIndex.value--;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  void _startTimer(int? seconds) {
    if (seconds == null) {
      remainSeconds = 0; // Default to 0 if null
      return;
    }

    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value =
            minutes.toString().padLeft(2, "0") + ":" + seconds.toString().padLeft(2, "0");
        remainSeconds--;
      }
    });
  }

  Future<void> complete() async {
    _timer?.cancel();

    // Calculate points
    int points = _calculatePoints();

    // Trigger vibration if points are 0
    if (points == 0) {
      _triggerVibration();
    }

    // Save the time of quiz completion
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastQuizTime', DateTime.now().toIso8601String());
      debugPrint('Quiz completion time saved: ${DateTime.now()}');
    } catch (e) {
      if (kDebugMode) {
        print("Error saving last quiz time: $e");
      }
    }

    Get.offAndToNamed(ResultScreen.routeName);
  }

  void _triggerVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // Vibrate for 500 ms
    }
  }

  int _calculatePoints() {
    return allQuestions
        .where((question) => question.selectedAnswer == question.correctAnswer)
        .toList()
        .length;
  }

  void tryAgain() {
    Get.find<QuizPaperController>().navigateToQuestions(
      paper: questionPaperModel,
      tryAgain: true,
    );
  }

  void navigateToHome() {
    _timer?.cancel();
    Get.offNamedUntil(HomeScreen.routeName, (route) => false);
  }
}
