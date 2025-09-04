import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/custom_text_styles.dart';
import 'package:fluuterek/controllers/question_papers/questions_controller.dart';
import 'package:fluuterek/screens/question/result_screen.dart';
import 'package:fluuterek/widgets/common/custom_app_bar.dart';
import 'package:get/get.dart';

import '../../widgets/common/background_decoration.dart';
import '../../widgets/content_area.dart';
import '../../widgets/questions/answer_card.dart';

class AnswerCheckScreen extends GetView<QuestionsController> {
  const AnswerCheckScreen({Key? key}) : super(key: key);

  static const String routeName = "/answercheckscreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Obx(
              () => Text(
            'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, "0")}',
            style: appBarTS,
          ), // Text
        ), // Obx
        showActionIcon: true,
        onMenuActionTap: () {
          Get.toNamed(ResultScreen.routeName);
        },
      ), // CustomAppBar
      body: BackgroundDecoration(
        child: Obx(
              () => Column(
            children: [
              Expanded(
                child: ContentArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text(
                          controller.currentQuestion.value?.question ?? 'No question available',
                        ), // Text
                        GetBuilder<QuestionsController>(
                          id: 'answer_review_list',
                          builder: (_) {
                            final currentQuestion = controller.currentQuestion.value;
                            if (currentQuestion == null || currentQuestion.answers == null) {
                              return const Text('No answers available'); // Obsługa przypadku null
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                if (index >= currentQuestion.answers!.length) {
                                  return const SizedBox(); // Bezpieczne sprawdzenie indeksu
                                }
                                final answer = currentQuestion.answers![index];
                                final selectedAnswer = currentQuestion.selectedAnswer;
                                final correctAnswer = currentQuestion.correctAnswer;

                                final String answerText =
                                    '${answer.identifier}. ${answer.answer}';

                                // Logika wyboru odpowiedzi
                                if (correctAnswer == selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  return CorrectAnswer(answer: answerText);
                                } else if (selectedAnswer == null) {
                                  return NotAnswered(answer: answerText);
                                } else if (correctAnswer != selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  return WrongAnswer(answer: answerText);
                                } else if (correctAnswer == answer.identifier) {
                                  return CorrectAnswer(answer: answerText);
                                }



                                return AnswerCard(
                                  answer: answerText,
                                  onTap: () {},
                                  isSelected: false,
                                ); // AnswerCard
                              },
                              separatorBuilder: (_, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: currentQuestion.answers?.length ?? 0,
                            );
                          },
                        ),
                      ],
                    ), // Column
                  ), // SingleChildScrollView
                ), // ContentArea
              ), // Expanded
            ],
          ), // Column
        ), // Obx
      ), // BackgroundDecoration
    ); // Scaffold
  }
}











  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Obx(
              () => Text(
            'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, "0")}',
            style: appBarTS,
          ), // Text
        ), // Obx
        showActionIcon: true,
        onMenuActionTap: () {
          Get.toNamed(ResultScreen.routeName);
        },
      ), // CustomAppBar
      body: BackgroundDecoration(
        child: Obx(
              () => Column(
            children: [
              Expanded(
                child: ContentArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text(
                          controller.currentQuestion.value?.question ?? 'No question available',
                        ), // Text
                        GetBuilder<QuestionsController>(
                          id: 'answer_review_list',
                          builder: (_) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                final answer = controller
                                    .currentQuestion.value!.answers[index];
                                final selectedAnswer = controller
                                    .currentQuestion.value!.selectedAnswer;
                                final correctAnswer = controller
                                    .currentQuestion.value!.correctAnswer;

                                final String answerText =
                                    '${answer.identifier}. ${answer.answer}';

                                // Logika wyboru odpowiedzi
                                if (correctAnswer == selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  // correct answer logic
                                } else if (selectedAnswer == null) {
                                  // not selected answer logic
                                } else if (correctAnswer == selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  // wrong answer logic
                                } else if (correctAnswer == answer.identifier) {
                                  // correct answer logic
                                }

                                return AnswerCard(
                                  answer: answerText,
                                  onTap: () {},
                                  isSelected: false,
                                ); // AnswerCard
                              },
                              separatorBuilder: (_, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount:
                              controller.currentQuestion.value!.answers.length,
                            );
                          },
                        ),
                      ],
                    ), // Column
                  ), // SingleChildScrollView
                ), // ContentArea
              ), // Expanded
            ],
          ), // Column
        ), // Obx
      ), // BackgroundDecoration
    ); // Scaffold
  }
}
*/