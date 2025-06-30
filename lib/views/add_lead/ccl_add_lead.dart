import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/addleads_controller.dart';
import '../../widgets/add_lead_widget/modern_text_field.dart';
import '../../widgets/add_lead_widget/personal_info_section.dart';
import '../../widgets/add_lead_widget/section_tile.dart';
import '../../widgets/add_lead_widget/voice_record_section.dart';

Widget buildCreditCardLoanBody() {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('Personal Information'),
      const SizedBox(height: 16),
      buildPersonalInfoSection(),
      const SizedBox(height: 32),
      buildSectionTitle('Contact Information'),
      const SizedBox(height: 16),
      buildContactInfoSectionForCC(),
      // Lead Details
      const SizedBox(height: 32),
      VoiceRecorderWidget(),

      const SizedBox(height: 100),
    ],
  );
}

Widget buildContactInfoSectionForCC() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();
  return Column(
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
      buildModernTextField(
        label: 'Email',
        controller: addLeadsController.emailController,
      ),
      const SizedBox(height: 20),
      Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Bank(s)",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _showBankMultiSelectDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      addLeadsController.selectedBanks.isEmpty
                          ? 'Select Bank(s)'
                          : addLeadsController.selectedBanks.join(', '),
                      style: TextStyle(
                        color: addLeadsController.selectedBanks.isEmpty
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ))

    ],
  );
}

void _showBankMultiSelectDialog() {
  final controller = Get.find<AddLeadsController>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.9,
        height: Get.height * 0.5,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select up to 2 Banks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                radius: const Radius.circular(10),
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: controller.availableBanks.length,
                  itemBuilder: (context, index) {
                    final bank = controller.availableBanks[index];

                    // ✅ Wrap only the CheckboxTile in Obx
                    return Obx(() {
                      final isSelected =
                      controller.selectedBanks.contains(bank);
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: CheckboxListTile(
                          dense: true,
                          title: Text(
                            bank,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.indigo
                                  : Colors.black,
                            ),
                          ),
                          secondary: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected
                                ? Colors.indigo
                                : Colors.grey[400],
                          ),
                          value: isSelected,
                          onChanged: (bool? selected) {
                            if (selected == true) {
                              if (controller.selectedBanks.length >= 2) {
                                Get.snackbar(
                                  "Limit reached",
                                  "You can only select 2 banks.",
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              controller.selectedBanks.add(bank);
                            } else {
                              controller.selectedBanks.remove(bank);
                            }
                          },
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("Done", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

