import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/services/voice_service.dart';
import '../services/api_services.dart';
import 'login-controller.dart'; // for token

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final RxBool isUploading = false.obs;
  final RxString profilePhotoUrl = ''.obs;

  Future<void> uploadProfilePhoto(File file) async {
    try {

      final response = await ApiService.updateProfilePhoto(file, authController.token.value);

      if (response['status'] == 'success') {
        Get.snackbar('Success', 'Profile photo updated successfully',backgroundColor: Colors.white);
        speak('Profile Photo Updated');
        // Update user profile if needed
      } else if (response['status'] == 'error' && response['errors'] != null) {
        // Extract error message
        final errorMsg = response['errors']['profile_photo']?.first ?? 'Unknown error';
        Get.snackbar('Error', errorMsg, backgroundColor: Colors.white, colorText: Colors.red);
      } else {
        Get.snackbar('Error', 'Failed to update profile photo', backgroundColor: Colors.white, colorText: Colors.red);
      }

    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', backgroundColor: Colors.white, colorText: Colors.red);
    } finally {
    }
  }

}
