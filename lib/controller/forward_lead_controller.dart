import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/forward_api_service.dart';
import '../views/lead_details_controller.dart';

class ForwardDropdownController extends GetxController {
  final selectedOption = RxnString();
  final isForwarded = false.obs;
  final receiverUserId = RxnInt();
  final receiverDesignation = ''.obs;
  final LeadDetailsController controller = Get.find<LeadDetailsController>();






  final List<String> options = const [
    'Forward to TL',
    'Forward to Operation',
    'Forward to Admin',
  ].obs;

  final RxInt animatedIndex = 0.obs;
  Timer? _rotationTimer;


  void selectOption(String value) {
    selectedOption.value = value;
  }

  void onForward(Function(String) onForwarded) {
    if (selectedOption.value != null) {
      onForwarded(selectedOption.value!);
    }
  }

  Future<void> loadForwardStatus(int leadId) async {
    final data = await ForwardApiService.getForwardStatus(leadId);
    if (data != null) {
      isForwarded.value = data['is_forwarded'] ?? false;
      receiverUserId.value = int.tryParse(data['receiver_user_id'].toString()) ?? 0;
      receiverDesignation.value = data['receiver_designation'] ?? '';

      if (isForwarded.value && selectedOption.value == null) {
        // Map the designation to the correct forward label
        switch (receiverDesignation.value.toLowerCase()) {
          case 'team_lead':
            selectedOption.value = 'Forward to TL';
            break;
          case 'operations':
            selectedOption.value = 'Forward to Operation';
            break;
          case 'admin':
            selectedOption.value = 'Forward to Admin';
            break;
          default:
            selectedOption.value = null;
        }
      }
    } else {
      Get.snackbar("Error", "Failed to fetch forward status",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }




  Future<void> forwardLead({
    required int leadId,
    required int forwardToId,
    required Function(String) onResult,
  }) async {
    final result = await ForwardApiService.forwardLead(
      leadId: leadId,
      forwardToId: forwardToId,
      forwardNotes: "Please review this lead", // or take from user input
    );

    onResult(result['message']);
    if (!result['success']) {
      Get.snackbar(
        'Error',
        result['message'],
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Success',
        result['message'],
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }




  @override
  void onClose() {
    _rotationTimer?.cancel();
    super.onClose();
  }
}
