// controllers/user_controller.dart
import 'package:get/get.dart';

import '../services/api_services.dart';
import 'login-controller.dart';

class UserController extends GetxController {
  final authController = Get.find<AuthController>(); // make sure AuthController is already put

  var isLoading = true.obs;
  var userData = Rxn<Map<String, dynamic>>();

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      final token = authController.token.value;
      final response = await ApiService.getUserProfile(token);
      userData.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
