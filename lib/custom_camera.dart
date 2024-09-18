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
              top:0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible:controller.isPreviousVisible().value,
                        child: InkWell(
                          onTap: (){
                            controller.onPrevious();
                          },
                          child: _getButton("Previous"),
                        ),
                      ),
                      Text(
                        controller.tagTitle.value,
                        style: const TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                      Visibility(
                        visible: controller.isNextVisible().value,
                        child: InkWell(
                          onTap: (){
                            controller.onNext();
                          },
                          child: _getButton("Next"),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.closeCamera();
                      },
                      child: _getButton("Done"),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      onPressed: () => controller.takePhoto(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        size: 48,
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
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

  Widget _getButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
