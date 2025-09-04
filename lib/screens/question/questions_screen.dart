import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/app_colors.dart';
import 'package:fluuterek/configs/themes/custom_text_styles.dart';
import 'package:fluuterek/screens/question/test_overview_screen.dart';
import 'package:fluuterek/widgets/common/background_decoration.dart';
import 'package:fluuterek/widgets/common/custom_app_bar.dart';
import 'package:fluuterek/widgets/common/question_place_holder.dart';
import 'package:fluuterek/widgets/questions/countdown_timer.dart';
import 'package:get/get.dart';

import '../../configs/themes/ui_parameters.dart';
import '../../controllers/question_papers/questions_controller.dart';
import '../../firebase_ref/loading_status.dart';
import '../../widgets/common/main_button.dart';
import '../../widgets/content_area.dart';
import '../../widgets/questions/answer_card.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluuterek/configs/themes/custom_text_styles.dart';
import 'package:fluuterek/widgets/common/background_decoration.dart';
import 'package:fluuterek/widgets/common/question_place_holder.dart';
import 'package:get/get.dart';

import '../../controllers/question_papers/questions_controller.dart';
import '../../firebase_ref/loading_status.dart';
import '../../widgets/content_area.dart';
import '../../widgets/questions/answer_card.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({Key? key}) : super(key: key);

  static const String routeName = "/questionsscreen";

  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
      appBar:  CustomAppBar(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(color: onSurfaceTextColor, width: 2),
            )
          ),
          child: Obx(() => CountdownTimer(
              time: controller.time.value,
            color: onSurfaceTextColor
          ))
        ),
        showActionIcon: true,
        titleWidget: Obx(
            ()=> Text(
              'Q. ${(controller.questionIndex.value+1).toString().padLeft(2,'0')}',
              style: appBarTS,

            )

      ),
        ),
      body: BackgroundDecoration(child: Obx(
            () =>
            Column(
              children: [
                if (controller.loadingStatus.value == LoadingStatus.loading)
                  const Expanded(
                    child: ContentArea(child: QuestionSreenHolder()),
                  ),
                if (controller.loadingStatus.value == LoadingStatus.completed)
                  Expanded(
                    child: ContentArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top:25),
                        child: Column(
                          children: [
                            Text(
                              controller.currentQuestion.value!.question ?? 'elo',
                              style: questionTS,
                            ),
                            GetBuilder<QuestionsController>(
                                id: 'answer_list',
                                builder: (context){



                                  final question = controller.currentQuestion.value;
                                  if (question == null || question.answers == null || question.answers!.isEmpty) {
                                    return const Center(child: Text("Brak odpowiedzi")); // Zwraca fallback
                                  }



                                  return ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 25),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index){

                                      //final answer = controller.currentQuestion.value!.answers[index];
                                      final answer = question.answers![index];

                                      return AnswerCard(
                                        answer: '${answer.identifier}.${answer.answer}',
                                        onTap: (){
                                          controller.selectedAnswer(answer.identifier);
                                        },
                                        isSelected: answer.identifier == controller.currentQuestion.value!.selectedAnswer,
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) =>
                                    const SizedBox(height: 10),
                                    //itemCount: controller.currentQuestion.value!.answers.length,
                                    itemCount: controller.currentQuestion.value?.answers?.length ?? 0,

                                  );
                                }
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: UIParameters.mobileScreenPadding,
                    child: Row(
                      children: [
                        Visibility(
                            visible: controller.isFirstQuestion,
                            child:  SizedBox(
                              width: 55,
                              height: 55,
                              child: MainButton(
                                onTap: () {
                                  controller.prevQuestion();
;                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Get.isDarkMode?onSurfaceTextColor:Theme.of(context).primaryColor,
                                ),
                              ),


                            )
                        ),
                        Expanded(
                          child: Visibility(
                            visible: controller.loadingStatus.value==LoadingStatus.completed,
                            child: MainButton(
                              onTap: () {
                                controller.isLastQuestion?Get.toNamed(TestOverviewScreen.routeName):
                                controller.nextQuestion();
                              },
                              title: controller.isLastQuestion? 'Complete': 'Next',
                            ),
                          ),
                        ),

                        // Visibility
                      ],
                    ),
                  ),
                ),

              ],
            ),
      )),
    );
  }
}


/*class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({Key? key}) : super(key: key);

  static const String routeName = "/questionsscreen";
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(child: Obx(
            () =>
            Column(
              children: [
                if (controller.loadingStatus.value == LoadingStatus.loading)
                  const Expanded(
                    child: ContentArea(child: QuestionSreenHolder()),
                  ),
                if (controller.loadingStatus.value == LoadingStatus.completed)
                  Expanded(
                    child: ContentArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              controller.currentQuestion.value!.question ?? 'elo',
                              style: questionTS,
                            ),
            GetBuilder<QuestionsController>(builder: (context){
            return ListView.separated(
            itemBuilder: (BuildContext context, int index){
              final answer = controller.currentQuestion.value!.answers[index];
              return AnswerCard(answer: '${answer.identifier}.${answer.answer}',
    onTap:(){
                  controller.selectedAnswer(answer.identifier);
    },
    isSelected: answer.identifier == controller.currentQuestion.value!.selectedAnswer,

    );
    },
            separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
            itemCount: controller.currentQuestion.value!.answers.length),
    } );

    ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      )),
    );
  }
}*/