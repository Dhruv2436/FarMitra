import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickXFile(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );
      return image;
    } catch (e) {
      debugPrint("Error picking image: $e");
      return null;
    }
  }

  Future<String?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      return image?.path;
    } catch (e) {
      // Handle permission errors or other exceptions
      // debugPrint('Error picking image: $e');
      return null;
    }
  }
}
