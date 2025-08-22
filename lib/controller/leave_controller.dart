import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/controller/login-controller.dart';

import '../services/api_services.dart';

class LeaveController extends GetxController {
  var leaveType = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  TextEditingController reasonController = TextEditingController();
  final options = ['Sick', 'Casual', 'Paid', 'Emergency'];
  var isLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();

  void pickDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  Future<void> applyForLeave() async {
    try {
      isLoading(true);

      // format dates
      String formattedStartDate =
      DateFormat('yyyy-MM-dd').format(startDate.value!);
      String formattedEndDate =
      DateFormat('yyyy-MM-dd').format(endDate.value!);

      print('the team lead id is ${authController.userData['team_lead_id']}');

      print("Before API call...");
      final response = await ApiService.applyLeave(
        token: authController.token.value,
        leaveType: leaveType.value,
        appliedTo: int.tryParse(authController.userData['team_lead_id'].toString()) ?? 0,
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        reason: reasonController.text.trim(),
      );
      print("After API call...");

      if (response != null && response.status == "success") {
        print('Success response: ${response.message}');
        Get.snackbar("Success", response.message ?? "Leave applied successfully",
            backgroundColor: Colors.green);
        leaveType.close();
        startDate.close();
        endDate.close();
        reasonController.clear();
      } else {
        print("Failed response object: $response");
        Get.snackbar("Failed", response?.message ?? "Failed to apply leave",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Caught error in applyForLeave: $e");
      Get.snackbar("Error", "An error occurred", backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }
}
