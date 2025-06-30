import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/widgets/custom_button.dart';
import '../controller/follow_up_controller.dart';

class FollowUpBottomSheet extends StatelessWidget {
  final String leadId;
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();

  FollowUpBottomSheet({super.key, required this.leadId});
  final FollowUpController followUpController = Get.put(FollowUpController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            20, // Ensures keyboard pushes UI up
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              "Add Follow-Up",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              final date = followUpController.selectedDate.value;
              return InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    followUpController.setDate(picked);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date == null
                            ? "Select Follow-Up Date"
                            : DateFormat.yMMMd().format(date),
                        style: TextStyle(
                          color: date == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            CustomButton(
              text: 'Set Follow-up Reminder',
              onPressed: () {
                final selectedDate = followUpController.selectedDate.value;
                if (_formKey.currentState!.validate() && selectedDate != null) {
                  followUpController.addFollowUp(
                    leadId: leadId,
                    type: followUpController.selectedType.value,
                    note: noteController.text,
                    followUpDate: selectedDate,
                  );
                  Get.back();
                  Get.snackbar("Success", "Set Follow-up Reminder Successfully",
                      backgroundColor: Colors.green.shade50,
                      colorText: Colors.black);
                } else {
                  Get.snackbar("Error", "Please fill all fields",
                      backgroundColor: Colors.red.shade50,
                      colorText: Colors.black);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
