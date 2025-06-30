import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/add_lead_widget/modern_dropdown.dart';

import '../../controller/addleads_controller.dart';
import '../../widgets/add_lead_widget/contact_info_section.dart';
import '../../widgets/add_lead_widget/lead_details_section.dart';
import '../../widgets/add_lead_widget/modern_text_field.dart';
import '../../widgets/add_lead_widget/personal_info_section.dart';
import '../../widgets/add_lead_widget/section_tile.dart';
import '../../widgets/add_lead_widget/voice_record_section.dart';

Widget buildBusinessLoanBody() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('Personal Information'),
      const SizedBox(height: 16),
      buildPersonalInfoSection(),
      const SizedBox(height: 32),
      buildSectionTitle('Contact Information'),
      const SizedBox(height: 16),
      buildContactInfoSection(),
      const SizedBox(height: 32),
      buildSectionTitle('Business Information'),
      const SizedBox(height: 16),
      buildBusinessInfoSection(),
      const SizedBox(height: 16),
      // Lead Details
      buildSectionTitle('Lead Details'),
      const SizedBox(height: 16),
      buildLeadDetailsSection(),
      const SizedBox(height: 32),
      VoiceRecorderWidget(),
      const SizedBox(height: 100),
    ],
  );
}

Widget buildBusinessInfoSection() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();
  return Column(
    children: [
      buildModernTextField(
        label: 'Business Name',
        controller: addLeadsController.companyNameController,
      ),
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'Turnover Amount',
        controller: addLeadsController.salaryController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the turnover amount';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      Obx(() => buildModernDropdown(
            label: 'Vintage Year',
            value: addLeadsController.selectedVintageYear.value,
            items: addLeadsController.vintageYearList,
            onChanged: (val) {
              addLeadsController.selectedVintageYear.value = val ?? '';
            },
          )),
      const SizedBox(height: 20),
      buildModernTextField(
        label: 'IT Return',
        controller: addLeadsController.itReturnController, // New field
        keyboardType: TextInputType
            .text, // Adjust based on IT return format (e.g., number or text)
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the IT return';
          }
          return null;
        },
      ),
    ],
  );
}
