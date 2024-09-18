import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspection_poc/image_list_screen_controller.dart';

class ImageListScreen extends StatelessWidget {
  final ImageListScreenController imageListScreenController =
      Get.put(ImageListScreenController());

  ImageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Obx(() => Text(
              'Vehicle Images (${imageListScreenController.vehicleImages.length})',
                style: const TextStyle(
                  color: Colors.white,
                ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: imageListScreenController.vehicleImages.length,
                  itemBuilder: (context, index) {
                    final imageItem =
                        imageListScreenController.vehicleImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: imageItem.imageFile != null
                                      ? Image.file(
                                          File(imageItem.imageFile!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child:
                                              const Center(child: Text('No Image')),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    imageItem.tagName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              imageListScreenController.removeImage(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar('Submit', 'Images submitted successfully!', snackPosition: SnackPosition.BOTTOM,);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Submit',style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
