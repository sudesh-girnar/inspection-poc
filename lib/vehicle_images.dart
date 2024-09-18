import 'package:camera/camera.dart';

class VehicleImage {
  String tagName = '';
  String tagId = '';
  XFile? imageFile;

  VehicleImage({
    required this.tagName,
    required this.tagId,
    this.imageFile,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      tagId: json['tagId'],
      tagName: json['tagName'],
    );
  }
}
