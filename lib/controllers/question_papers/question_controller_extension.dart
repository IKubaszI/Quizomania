import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluuterek/controllers/question_papers/questions_controller.dart';
import 'package:get/get.dart';

import '../../firebase_ref/references.dart';
import '../auth_controller.dart';

extension QuestionsControllerExtension on QuestionsController {
  int get correctQuestionCount => allQuestions
      .where((element) => element.selectedAnswer == element.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionCount out of ${allQuestions.length} are correct!';
  }

  String get points {
    final totalQuestions = allQuestions.length;
    final totalSeconds = questionPaperModel.timeSeconds ?? 0;
    final remainingSeconds = remainSeconds ?? 0;

    if (totalQuestions == 0 || totalSeconds == 0) {
      return '0.00'; // Uniknięcie dzielenia przez zero
    }

    var points = (correctQuestionCount / totalQuestions) * 100 *
        ((totalSeconds - remainingSeconds) / totalSeconds) * 100;

    return points.toStringAsFixed(2);
  }

Future<void> saveTestResults() async {
  var batch = fireStore.batch();
  User? _user = Get.find<AuthController>().getUser();
  if (_user == null) return;

  // Zapis wyników w Firebase
  batch.set(
    userRF.doc(_user.email)
        .collection('myrecent_tests')
        .doc(questionPaperModel.id),
    {
      "points": points,
      "correct_answer": '$correctQuestionCount/${allQuestions.length}',
      "question_id": questionPaperModel.id,
      "time": questionPaperModel.timeSeconds! - remainSeconds,
    },
  );

  // Commit operacji do Firebase
  await batch.commit();

  // Powrót na stronę główną
  navigateToHome();
}
}
