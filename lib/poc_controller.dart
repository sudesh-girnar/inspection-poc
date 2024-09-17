import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import 'custom_camera.dart';

class PocController extends GetxController {
  Rxn<Map<String, dynamic>> data = Rxn();

  Rxn<Map<String, dynamic>> currentPage = Rxn();

  RxBool showNextButton = RxBool(true);
  RxBool showPreviousButton = RxBool(false);

  RxInt currentPageIndex = 0.obs;


  Map<String, Map<String, dynamic>> formValuesByTitle = {};


  Future<void> loadJsonAsset() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final json = jsonDecode(jsonString);
    data.value = json as Map<String, dynamic>;

    _changePage();
  }

  void _changePage() {
    currentPage.value = data.value!["subCategories"][currentPageIndex.value];
  }

  void nextPage() {
    if (currentPageIndex.value < data.value!["subCategories"].length - 1) {
      currentPageIndex.value = currentPageIndex.value + 1;
      _changePage();

      if (showPreviousButton.isFalse) {
        showPreviousButton(true);
      }
      if (currentPageIndex.value == data.value!["subCategories"].length - 1) {
        showNextButton(false);
      }
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value = currentPageIndex.value - 1;
      _changePage();

      if (currentPageIndex.value <= 0) {
        showPreviousButton(false);
      }
      if (showNextButton.isFalse) {
        showNextButton(true);
      }
    }
  }

  void savePage(String formTitle, Map<String, dynamic> formValues) {
    formValuesByTitle[formTitle] = formValues;
  }

  void startImageCapture() async {
    final List<String>? capturedImagePaths = await Get.to(() => CustomCamera());

    if (capturedImagePaths != null && capturedImagePaths.isNotEmpty) {
      final List<File> capturedImages = capturedImagePaths.map((path) => File(path)).toList();
      debugPrint("Captured ${capturedImages.length} images");
    } else {
      debugPrint("no images captured");
    }

  }
}
