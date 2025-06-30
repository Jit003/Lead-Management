import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';

import '../services/api_services.dart';

class ProfileUpdateController extends GetxController {
  final ApiService apiService = ApiService();
  final AuthController authController = Get.find<AuthController>(); // Right!

  var isUpdating = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> updateProfile() async {
    isUpdating.value = true;



    final result = await apiService.updateProfile(
      token: authController.token.value,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    isUpdating.value = false;

    if (result['success']) {
      // Update the user data in the AuthController
      authController.userData.value = result['user'];

      Get.snackbar('Success ', result['message'], backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', result['message'], backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
