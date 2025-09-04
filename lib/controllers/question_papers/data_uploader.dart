import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluuterek/firebase_ref/loading_status.dart';
import 'package:fluuterek/firebase_ref/references.dart';
import 'package:fluuterek/models/question_paper_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataUploader extends GetxController {
  @override
  void onReady() {
    uploadData();
    super.onReady();
  }

  final loadingStatus = LoadingStatus.loading.obs;  //ładowanie statusu obs

  Future<void> uploadData() async {
    loadingStatus.value = LoadingStatus.loading; //0
    try {
      final fireStore = FirebaseFirestore.instance;
      final manifestContent = await DefaultAssetBundle.of(Get.context!)
          .loadString("AssetManifest.json");
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Pobranie plików z katalogu `assets/DB/paper`
      final papersInAssets = manifestMap.keys
          .where((path) =>
      path.startsWith("assets/DB/paper") && path.contains(".json"))
          .toList();

      List<QuestionPaperModel> questionPapers = [];
      for (var paper in papersInAssets) {
        String stringPaperContent = await rootBundle.loadString(paper);
        questionPapers
            .add(QuestionPaperModel.fromJson(json.decode(stringPaperContent)));
      }

      var batch = fireStore.batch();

      // Dodawanie dokumentów do Firestore
      for (var paper in questionPapers) {
        // Główna kolekcja `questionPapers`
        batch.set(questionPaperRF.doc(paper.id), {
          "title": paper.title,
          "image_url": paper.imageUrl,
          "description": paper.description,
          "time_seconds": paper.timeSeconds,
          "questions_count":
          paper.questions == null ? 0 : paper.questions!.length
        });

        // Podkolekcja `questions`
        for (var question in paper.questions!) {
          final questionPath =
          questionRF(paperId: paper.id!, questionId: question.id!);

          batch.set(questionPath, {
            "question": question.question,
            "correct_answer": question.correctAnswer,
          });

          // Podkolekcja `answers` dla każdego pytania
          for (var answer in question.answers!) {
            batch.set(
              questionPath.collection('answers').doc(answer.identifier),
              {
                "identifier": answer.identifier,
                "answer": answer.answer,
              },
            );
          }
        }
      }

      // Wykonanie batch commit
      await batch.commit();
      loadingStatus.value = LoadingStatus.completed;
      print('Data uploaded successfully!');
    } catch (e) {
      print('Error during uploadData: $e');
    }
  }

}
