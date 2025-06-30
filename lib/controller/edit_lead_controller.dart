import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/allleads_controller.dart';
import 'package:kredipal/routes/app_routes.dart';
import '../models/all_leads_model.dart';
import '../services/lead_api_service.dart';
import '../views/lead_details_controller.dart';

class LeadEditController extends GetxController {
  final LeadsApiService _apiService = Get.put(LeadsApiService());
  final AllLeadsController allLeadsController = Get.find<AllLeadsController>();
  final LeadDetailsController controller = Get.find<LeadDetailsController>();
  List<String> successPer = ['50', '60', '70', '80', '90', '100'];






  Rx<Leads?> lead = Rx<Leads?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final companyNameController = TextEditingController();
  final leadAmountController = TextEditingController();
  final salaryController = TextEditingController();
  final remarksController = TextEditingController();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null); // dob
  RxString selectedSuccessRatio = ''.obs;
  RxString leadTypeValue = ''.obs;
  RxString selectedMonth = ''.obs; // expected_month
  RxString voiceFilePath = ''.obs;


  @override
  void onReady() {
    super.onReady();
    if (Get.arguments != null) {
      final int leadId = Get.arguments;
      fetchLeadForEdit(leadId);
    }
  }




  Future<void> fetchLeadForEdit(int leadId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      resetForm();
      final fetchedLead = await _apiService.getLeadForEdit(leadId);
      lead.value = fetchedLead;
      // Pre-fill form
      nameController.text = fetchedLead.name!;
      phoneController.text = fetchedLead.phone ?? '';
      locationController.text = fetchedLead.location ?? '';
      companyNameController.text = fetchedLead.companyName ?? '';
      leadAmountController.text = fetchedLead.leadAmount ?? '';
      salaryController.text = fetchedLead.salary ?? '';
      remarksController.text = fetchedLead.remarks ?? '';
      selectedDate.value = DateTime.tryParse(fetchedLead.dob ?? '');
      selectedSuccessRatio.value = fetchedLead.successPercentage?.toString() ?? '';
      leadTypeValue.value = fetchedLead.leadType ?? '';
      selectedMonth.value = fetchedLead.expectedMonth ?? '';
      voiceFilePath.value = fetchedLead.voiceRecording ?? '';

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLead(int leadId) async {
    final data = {
      "name": nameController.text,
      "phone": phoneController.text,
      "location": locationController.text,
      "company_name": companyNameController.text,
      "lead_amount": leadAmountController.text,
      "salary": salaryController.text,
      "remarks": remarksController.text ,
    };
    // ✅ Add email only if it's not empty
    if (emailController.text.trim().isNotEmpty) {
      data["email"] = emailController.text.trim();
    }



    // ✅ Add dob only if a date is selected
    if (selectedDate.value != null) {
      data["dob"] = selectedDate.value!.toIso8601String();
    }

    try {
      isLoading.value = true;
      await _apiService.updateLead(leadId, data);
      Get.toNamed(AppRoutes.home);
      Get.snackbar("Success", "Lead updated successfully");
      Get.delete<LeadDetailsController>();

      allLeadsController.fetchAllLeads();
      controller.fetchLeadDetails(leadId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    lead.value = null;
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    locationController.clear();
    companyNameController.clear();
    leadAmountController.clear();
    salaryController.clear();
    remarksController.clear();
    selectedDate.value = null;
    selectedSuccessRatio.value = '';
    leadTypeValue.value = '';
    selectedMonth.value = '';
    voiceFilePath.value = '';
  }

}
