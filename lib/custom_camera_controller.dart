import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspection_poc/image_list_screen.dart';
import 'package:inspection_poc/vehicle_images.dart';

class CustomCameraController extends GetxController {
  late CameraController cameraController;
  var cameraInitialized = false.obs;
  RxBool isLandscape = false.obs;
  RxBool isCapturing = false.obs;
  RxList<VehicleImage> vehicleTags = <VehicleImage>[].obs;
  RxList<VehicleImage> capturedVehicleImages = <VehicleImage>[].obs;
  RxInt currentImageIndex = 0.obs;
  RxString tagTitle = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadJsonAsset();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    initCamera();
  }

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/vehicle_images.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      vehicleTags.value = jsonList
          .map((item) => VehicleImage.fromJson(item as Map<String, dynamic>))
          .toList();
      updateTitle();
    } catch (e) {
      debugPrint('error loading json: $e');
    }
  }

  void addOrUpdateImage(String tagId, XFile newImageFile, String tagName) {
    int index = capturedVehicleImages.indexWhere((item) => item.tagId == tagId);

    if (index != -1) {
      capturedVehicleImages[index].imageFile = newImageFile;
    } else {
      capturedVehicleImages.add(VehicleImage(tagId: tagId, tagName: tagName, imageFile: newImageFile));
    }
  }

  void onNext(){
    if(currentImageIndex.value < vehicleTags.length-1){
      currentImageIndex.value = currentImageIndex.value + 1;
      updateTitle();
    }
  }

  void onPrevious(){
    if(currentImageIndex.value > 0){
      currentImageIndex.value = currentImageIndex.value - 1;
      updateTitle();
    }
  }

  RxBool isPreviousVisible(){
    return (currentImageIndex.value > 0).obs;
  }

  RxBool isNextVisible(){
    return (currentImageIndex.value < vehicleTags.length-1).obs;
  }

  void updateTitle(){
    tagTitle.value = vehicleTags[currentImageIndex.value].tagName;
  }

  Future<void> initCamera() async {
    try {
      final cameraDescription = await availableCameras().then(
            (cameras) => cameras.first,
      );
      cameraController = CameraController(cameraDescription, ResolutionPreset.max);
      await cameraController.initialize();
      cameraInitialized.value = true;
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> takePhoto() async {
    if (isCapturing.value) return;

    isCapturing(true);
    try {
      final XFile image = await cameraController.takePicture();
      addOrUpdateImage(vehicleTags[currentImageIndex.value].tagId, image, vehicleTags[currentImageIndex.value].tagName);
    } catch (e) {
      debugPrint("Capture Error: $e");
    } finally {
      onNext();
      isCapturing(false);
    }
  }

  void closeCamera() {
    if (capturedVehicleImages.isNotEmpty) {
      Get.off(() => ImageListScreen(), arguments: capturedVehicleImages.toList());
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    cameraController.dispose();
    super.onClose();
  }
}