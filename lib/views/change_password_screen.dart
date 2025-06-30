import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/password_visibility_controller.dart';
import '../controller/change_password_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  // Use separate visibility controllers for each password field
  final currentVisibility = Get.put(PasswordVisibilityController(), tag: 'current');
  final newVisibility = Get.put(PasswordVisibilityController(), tag: 'new');
  final confirmVisibility = Get.put(PasswordVisibilityController(), tag: 'confirm');

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required PasswordVisibilityController visibilityController,
  }) {
    return Obx(() => TextField(
      controller: controller,
      obscureText: visibilityController.isObscure.value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            visibilityController.isObscure.value
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: visibilityController.toggleVisibility,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Password'),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPasswordField(
              label: "Current Password",
              controller: controller.currentPasswordController,
              visibilityController: currentVisibility,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              label: "New Password",
              controller: controller.newPasswordController,
              visibilityController: newVisibility,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              label: "Confirm Password",
              controller: controller.confirmPasswordController,
              visibilityController: confirmVisibility,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Update Password',
              onPressed: controller.changePassword,
            ),
          ],
        ),
      )),
    );
  }
}
