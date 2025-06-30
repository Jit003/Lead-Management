import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/addleads_controller.dart';
import 'modern_dropdown.dart';
import 'modern_text_field.dart';

Widget buildLeadDetailsSection() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();
  return Column(
    children: [
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'Loan Amount',
        controller: addLeadsController.leadAmountController,
        keyboardType: TextInputType.number,
      ),
     // const SizedBox(height: 20),
      // Obx(() => buildModernDropdown(
      //   label: 'Success Percentage',
      //   value: addLeadsController.selectedSuccessRatio.value,
      //   items: addLeadsController.successPer,
      //   onChanged: (val) {
      //     addLeadsController.selectedSuccessRatio.value = val ?? '';
      //   },
      // )),
      const SizedBox(height: 20),
      Obx(() => buildModernDropdown(
        label: 'Expected Month',
        value: addLeadsController.selectedMonth.value,
        items: addLeadsController.expectedMonth,
        onChanged: (val) {
          addLeadsController.selectedMonth.value = val ?? '';
        },
      )),
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'Remarks',
        controller: addLeadsController.remarksController,
        maxLines: 4,
      ),
    ],
  );
}
