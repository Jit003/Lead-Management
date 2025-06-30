import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/addleads_controller.dart';

Widget buildModernDatePicker() {
  final AddLeadsController addLeadsController = Get.find<AddLeadsController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Date of Birth',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
      ),
      const SizedBox(height: 8),
      Obx(() {
        final date = addLeadsController.selectedDate.value;
        return GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF1A1A1A),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Color(0xFF1A1A1A),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              addLeadsController.setDate(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? "Select Date of Birth"
                        : DateFormat.yMMMd().format(date),
                    style: TextStyle(
                      fontSize: 16,
                      color: date == null ? const Color(0xFF999999) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF666666),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }),
    ],
  );
}
