import 'package:get/get.dart';
import 'package:inspection_poc/vehicle_images.dart';

class ImageListScreenController extends GetxController {
  var vehicleImages = <VehicleImage>[].obs;

  void removeImage(int index) {
    vehicleImages.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      vehicleImages.assignAll(Get.arguments as List<VehicleImage>);
    }
  }

}


