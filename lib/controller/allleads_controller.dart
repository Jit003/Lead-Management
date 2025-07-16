import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/edit_lead_controller.dart';
import 'package:kredipal/routes/app_routes.dart';
import '../models/all_leads_model.dart';
import '../services/lead_api_service.dart';

class AllLeadsController extends GetxController {
  final LeadsApiService _apiService = Get.put(LeadsApiService());

  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();


  final RxList<Leads> allLeads = <Leads>[].obs;
  RxList<Leads> filteredLeads = <Leads>[].obs;
  final Rx<Aggregates?> aggregates = Rx<Aggregates?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'all'.obs;
  final RxString selectedLeadType = 'All'.obs;
  final RxString dateFilter = 'this_month'.obs;
  final RxnString selectedMonth = RxnString(); // ✅ Add this line


  @override
  void onInit() {
    super.onInit();
    selectedStatus.value = 'all';
    selectedLeadType.value = 'All';
    fetchAllLeads();
  }

  // Change fetchAllLeads to accept filters
  Future<void> fetchAllLeads({
    String? leadType,
    String? status,
    String? expectedMonth,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Decide dateFilter value
      String? filterType;
      String? start;
      String? end;

      if (dateFilter.value == 'date_range' &&
          startDate != null &&
          endDate != null) {
        filterType = 'date_range';
        start = formatDate(startDate);
        end = formatDate(endDate);
      } else {
        filterType = dateFilter.value;
      }

      final response = await _apiService.getAllLeads(
        leadType: leadType,
        status: status,
        expectedMonth: expectedMonth,
        dateFilter: filterType,
        startDate: start,
        endDate: end,
        search: searchQuery.value, // ✅ Include search here
      );

      if (response.status == 'success' && response.data != null) {
        allLeads.value = response.data!.leads ?? [];
        aggregates.value = response.data!.aggregates;
        filteredLeads.value = allLeads;
        Get.delete<LeadEditController>();
      } else {
        throw Exception(response.message ?? 'Failed to fetch leads');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch leads: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

// Update filter setters to fetch filtered data from API
  void updateStatusFilter(String value) {
    selectedStatus.value = value;
    fetchAllLeads(
      leadType: selectedLeadType.value == 'All' ? null : selectedLeadType.value,
      status: value == 'all' ? null : value,
      startDate: startDate.value,
      endDate: endDate.value,
    );
  }

  void updateStatusLeadType(String value) {
    selectedLeadType.value = value;
    fetchAllLeads(
      leadType: value == 'All' ? null : value,
      status: selectedStatus.value == 'all' ? null : selectedStatus.value,
      startDate: startDate.value,
      endDate: endDate.value,
    );
  }

  void updateExpectedMonth(String value) {
    fetchAllLeads(
      leadType: selectedLeadType.value == 'All' ? null : selectedLeadType.value,
      status: selectedStatus.value == 'all' ? null : selectedStatus.value,
      expectedMonth: value == 'All' ? null : value,
    );
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    fetchAllLeads(
      leadType: selectedLeadType.value == 'All' ? null : selectedLeadType.value,
      status: selectedStatus.value == 'all' ? null : selectedStatus.value,
      startDate: startDate.value,
      endDate: endDate.value,
    );
  }




  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return const Color(0xFF27AE60);
      case 'pending':
        return const Color(0xFFE67E22);
      case 'completed':
        return const Color(0xFF9B59B6);
      case 'rejected':
        return const Color(0xFFE74C3C);
      default:
        return Colors.blue;
    }
  }

  String formatCurrency(dynamic amount) {
    try {
      double parsedAmount = 0;

      if (amount is int) {
        parsedAmount = amount.toDouble();
      } else if (amount is String) {
        parsedAmount = double.tryParse(amount) ?? 0;
      } else {
        parsedAmount = 0;
      }

      return '₹${parsedAmount.toStringAsFixed(2)}';
    } catch (_) {
      return '₹0.00';
    }
  }

  void navigateToLeadDetails(Leads lead) {
    Get.toNamed(AppRoutes.leadDetails, arguments: lead);
  }



  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }


}
