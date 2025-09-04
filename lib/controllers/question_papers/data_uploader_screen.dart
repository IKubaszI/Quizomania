import 'package:flutter/material.dart';
import 'package:fluuterek/controllers/question_papers/data_uploader.dart';
import 'package:fluuterek/firebase_ref/loading_status.dart';
import 'package:get/get.dart';

class DataUploaderScreen extends StatelessWidget {
  DataUploaderScreen({Key? key}) : super(key: key);
  final DataUploader controller = Get.put(DataUploader());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Text(
          controller.loadingStatus.value == LoadingStatus.completed? "Uploading completed": "Uploading...",
        )),
      ),
    );
  }
}
