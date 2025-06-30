import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/password_visibility_controller.dart';

class PasswordTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final PasswordVisibilityController visibilityController;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.visibilityController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
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
}
