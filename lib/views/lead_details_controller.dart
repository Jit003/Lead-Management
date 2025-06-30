import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/all_leads_model.dart';
import '../services/lead_api_service.dart';

class LeadDetailsController extends GetxController {
  final LeadsApiService _apiService = Get.find<LeadsApiService>();

  final Rx<Leads?> leadDetails = Rx<Leads?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    final Leads? lead = Get.arguments as Leads?;
    if (lead != null) {
      fetchLeadDetails(lead.id!); // ← always fetch from API
    }
  }


  Future<void> fetchLeadDetails(int leadId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getLeadDetails(leadId);
      leadDetails.value = response;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch lead details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return const Color(0xFF27AE60);
      case 'pending':
        return const Color(0xFFE67E22);
      case 'disbursed':
        return const Color(0xFF9B59B6);
      case 'rejected':
        return const Color(0xFFE74C3C);
      default:
        return Colors.blue;
    }
  }

  String formatCurrency(String? amount) {
    if (amount == null) return '₹0';
    try {
      double value = double.parse(amount);
      if (value >= 10000000) {
        return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
      } else if (value >= 100000) {
        return '₹${(value / 100000).toStringAsFixed(1)}L';
      } else if (value >= 1000) {
        return '₹${(value / 1000).toStringAsFixed(1)}K';
      } else {
        return '₹${value.toStringAsFixed(0)}';
      }
    } catch (e) {
      return '₹0';
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void goBack() {
    Get.back();
  }
}
