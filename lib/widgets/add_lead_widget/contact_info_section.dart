import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/addleads_controller.dart';
import 'modern_dropdown.dart';
import 'modern_text_field.dart';
Widget buildContactInfoSection() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();
  return Obx(() {
    print(
        'Rendering Contact Info Section - State: ${addLeadsController.selectedState.value}, '
            'District: ${addLeadsController.selectedDistrict.value}, '
            'City: ${addLeadsController.selectedCity.value}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildModernTextField(
          label: 'Phone Number',
          controller: addLeadsController.phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        buildModernDropdown(
          label: 'State',
          hint: 'Select a state',
          value: addLeadsController.selectedState.value.isNotEmpty
              ? addLeadsController.selectedState.value
              : null,
          items: addLeadsController.availableStates,
          onChanged: (val) {
            addLeadsController.selectedState.value = val ?? '';
            addLeadsController.selectedDistrict.value = '';
            addLeadsController.selectedCity.value = '';
            addLeadsController.availableDistricts.clear();
            addLeadsController.availableCities.clear();
          },
          isEnabled: addLeadsController.availableStates.isNotEmpty,
        ),
        const SizedBox(height: 20),
        if (addLeadsController.selectedState.value.isNotEmpty &&
            addLeadsController.availableDistricts.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildModernDropdown(
                label: 'District',
                hint: 'Select a district',
                value: addLeadsController.selectedDistrict.value.isNotEmpty
                    ? addLeadsController.selectedDistrict.value
                    : null,
                items: addLeadsController.availableDistricts,
                onChanged: (val) {
                  addLeadsController.selectedDistrict.value = val ?? '';
                  addLeadsController.selectedCity.value = '';
                  addLeadsController.availableCities.clear();
                },
                isEnabled: addLeadsController.availableDistricts.isNotEmpty,
              ),
              const SizedBox(height: 20),
            ],
          ),
        // City Dropdown - shown only if a district is selected and cities are available
        if (addLeadsController.selectedDistrict.value.isNotEmpty &&
            addLeadsController.availableCities.isNotEmpty)
          buildModernDropdown(
            label: 'City',
            hint: 'Select a city',
            value: addLeadsController.selectedCity.value.isNotEmpty
                ? addLeadsController.selectedCity.value
                : null,
            items: addLeadsController.availableCities,
            onChanged: (val) {
              addLeadsController.selectedCity.value = val ?? '';
            },
            isEnabled: addLeadsController.availableCities.isNotEmpty,
          ),
      ],
    );
  });
}