import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluuterek/widgets/content_area.dart';
import 'package:fluuterek/widgets/questions/answer_card.dart';
import 'package:fluuterek/widgets/questions/question_number_card.dart';
import 'package:get/get.dart';

import '../../configs/themes/custom_text_styles.dart';
import '../../configs/themes/ui_parameters.dart';
import '../../controllers/question_papers/questions_controller.dart';
import '../../widgets/common/background_decoration.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/main_button.dart';
import '../../widgets/questions/countdown_timer.dart';

class TestOverviewScreen extends GetView<QuestionsController> {
  const TestOverviewScreen({Key? key}) : super(key: key);

  static const String routeName = "/testoverview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: controller.completedTest, // Teraz będzie działać, jeśli QuestionsController jest odpowiednio skonfigurowany
      ), // CustomAppBar
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
              child: ContentArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CountdownTimer(
                          color: UIParameters.isDarkMode()
                              ? Theme.of(context).textTheme.bodyLarge!.color
                              : Theme.of(context).primaryColor,
                          time: '',
                        ), // CountdownTimer
                        Obx(
                              () => Text(
                            '${controller.time} Remaining',
                            style: countDownTimerTs(),
                          ), // Text
                        ), // Obx
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: controller.allQuestions.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Get.width ~/75,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8


                          ),
                          itemBuilder: (_, index){
                            AnswerStatus? _answerStatus;
                            if(controller.allQuestions[index].selectedAnswer!=null){
                              _answerStatus = AnswerStatus.answered;
                            }
                            return QuestionNumberCard(
                                index: index+11,
                                status: _answerStatus,
                                onTap: ()=>controller.jumpToQuestion(index)
                            );
                          }),
                    )

                  ],
                ) // Row
              ), // ContentArea
            ),
            ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: UIParameters.mobileScreenPadding,
                child: MainButton(
                  onTap: () {
                    controller.complete();
                  },
                  title: 'Complete',
                ), // MainButton
              ), // Padding
            ), // ColoredBox

          ],
        ), // Column
      ), // BackgroundDecoration
    ); // Scaffold
  }
}
