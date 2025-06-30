import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/addleads_controller.dart';
import 'modern_text_field.dart';

Widget buildBusinessInfoSection() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();
  return Column(
    children: [
      buildModernTextField(
        label: 'Company Name',
        controller: addLeadsController.companyNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the company name';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'Salary',
        controller: addLeadsController.salaryController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the salary';
          }
          return null;
        },
      ),
    ],
  );
}
