import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_services.dart';
import 'login-controller.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  final ApiService apiService = ApiService();
  final authController = Get.find<AuthController>();

  Future<void> changePassword() async {
    isLoading.value = true;

    final result = await apiService.changePassword(
      token: authController.token.value,
      currentPassword: currentPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    isLoading.value = false;

    if (result['success']) {
      Get.snackbar('Success', result['message'],
          backgroundColor: Colors.green, colorText: Colors.white);
      // Optionally clear fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      Get.snackbar('Error', result['message'],
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
