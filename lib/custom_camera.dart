import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspection_poc/custom_camera_controller.dart';

class CustomCamera extends StatelessWidget {
  final CustomCameraController controller = Get.put(CustomCameraController());

  CustomCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.cameraInitialized.value) {
        return Container();
      }
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: controller.cameraController.value.aspectRatio,
                child: CameraPreview(controller.cameraController),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => controller.closeCamera(),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () => controller.takePhoto(),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Icon(
                  size: 48,
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
            if (controller.isCapturing.value)
              _getLoader()
          ],
        ),
      );
    });
  }

  Widget _getLoader(){
    return const Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 8,
            ),
          ),
        ),
      ),
    );
  }

}
