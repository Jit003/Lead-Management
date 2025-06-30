import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/addleads_controller.dart';
import 'modern_text_field.dart';

Widget buildPersonalInfoSection() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

  return Column(
    children: [
      buildModernTextField(
        label: 'Full Name',
        controller: addLeadsController.nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the name';
          }
          return null;
        },
      ),
    ],
  );
}
