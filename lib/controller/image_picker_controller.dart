import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kredipal/controller/profile_photo_controller.dart';

class ImagePickerController extends GetxController {
  var pickedImagePath = ''.obs;
  final ProfileController profileController = Get.put(ProfileController());

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImagePath.value = picked.path; // ✅ Update this line
      final file = File(picked.path);
      profileController.uploadProfilePhoto(file);
    }
  }

}
