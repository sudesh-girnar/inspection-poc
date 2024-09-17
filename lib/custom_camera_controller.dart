import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomCameraController extends GetxController {
  late CameraController cameraController;
  var cameraInitialized = false.obs;
  RxBool isLandscape = false.obs;
  RxBool isCapturing = false.obs;
  final List<XFile> _capturedImages = [];

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    initCamera();
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
      _capturedImages.add(image);
    } catch (e) {
      debugPrint("Capture Error: $e");
    } finally {
      isCapturing(false);
    }
  }

  void closeCamera() {
    if (_capturedImages.isNotEmpty) {
      Get.back(result: _capturedImages.map((file) => file.path).toList());
    } else {
      Get.back(result:<String>[] );
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