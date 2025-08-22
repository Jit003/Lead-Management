import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kredipal/controller/dashboard_controller.dart';
import 'package:kredipal/controller/voice_record_controller.dart';
import '../services/lead_api_service.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';
import 'allleads_controller.dart';
import 'login-controller.dart';

class AddLeadsController extends GetxController {
  final AllLeadsController allLeadsController = Get.find<AllLeadsController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final RxBool isFetching = false.obs;

  final LeadsApiService leadsApiService = Get.find<LeadsApiService>();

  final RxBool isSaving = false.obs; // For saving lead

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final companyNameController = TextEditingController();
  final leadAmountController = TextEditingController();
  final salaryController = TextEditingController();
  final remarksController = TextEditingController();
  final businessBudgetController = TextEditingController();
  final itReturnController = TextEditingController();
  final businessVintageController = TextEditingController();
  final RxString selectedVintageYear = '2'.obs;
  List<String> vintageYearList = List.generate(
      10,
      (index) =>
          '${index + 1}'); // default value to pass validation// New field for Business Vintage

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxString selectedSuccessRatio = ''.obs;
  RxString leadTypeValue = 'personal_loan'.obs;
  RxString selectedMonth = ''.obs;
  RxString selectedLocation = ''.obs;
  RxString voiceFilePath = ''.obs;
  final authController = Get.find<AuthController>();
  final VoiceRecorderController voiceRecorderController =
      Get.put(VoiceRecorderController());

  List<String> odishaDistricts = [
    'Angul',
    'Balangir',
    'Balasore',
    'Bargarh',
    'Bhadrak',
    'Boudh',
    'Cuttack',
    'Deogarh',
    'Dhenkanal',
    'Gajapati',
    'Ganjam',
    'Jagatsinghpur',
    'Jajpur',
    'Jharsuguda',
    'Kalahandi',
    'Kandhamal',
    'Kendrapara',
    'Kendujhar',
    'Khordha',
    'Koraput',
    'Malkangiri',
    'Mayurbhanj',
    'Nabarangpur',
    'Nayagarh',
    'Nuapada',
    'Puri',
    'Rayagada',
    'Sambalpur',
    'Subarnapur',
    'Sundargarh',
  ];

  final RxString selectedState = ''.obs;
  final RxString selectedDistrict = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxList<String> availableStates = <String>[].obs;
  final RxList<String> availableDistricts = <String>[].obs;
  final RxList<String> availableCities = <String>[].obs;
  final RxMap<String, int> stateIdMap = <String, int>{}.obs;
  final RxMap<String, int> districtIdMap = <String, int>{}.obs;
  final RxMap<String, int> cityIdMap = <String, int>{}.obs;

  // Controller
  final RxList<String> selectedBanks = <String>[].obs;

  List<String> availableBanks = [
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'SBI',
    'Kotak Mahindra',
    'Yes Bank',
    'Bank of Baroda',
    'IndusInd Bank',
  ];

  List<String> successPer = ['50', '60', '70', '80', '90', '100'];
  List<String> expectedMonth = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> leadType = [
    'personal_loan',
    'business_loan',
    'home_loan',
    'creditcard_loan',
  ];

  final isLoading = false.obs;

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onInit() {
    super.onInit();
    print(
        'AddLeadsController: onInit called, Token: ${authController.token.value}');
    if (authController.token.value.isNotEmpty) {
      fetchStates();
    } else {
      print('AddLeadsController: Token is empty, skipping fetchStates');
      Get.snackbar('Error', 'Please log in to fetch states',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (availableStates.isEmpty && authController.token.value.isNotEmpty) {
      fetchStates();
    }
  }

  void setupWatchers() {
    ever(selectedState, (_) {
      if (selectedState.value.isNotEmpty &&
          stateIdMap.containsKey(selectedState.value)) {
        fetchDistricts();
      } else {
        availableDistricts.clear();
        selectedDistrict.value = '';
        availableCities.clear();
        selectedCity.value = '';
        districtIdMap.clear();
        cityIdMap.clear();
      }
    });
    ever(selectedDistrict, (_) {
      if (selectedDistrict.value.isNotEmpty &&
          districtIdMap.containsKey(selectedDistrict.value)) {
        fetchCities();
      } else {
        availableCities.clear();
        selectedCity.value = '';
        cityIdMap.clear();
      }
    });
  }

  Future<void> fetchStates() async {
    try {
      isFetching.value = true;
      final response =
          await leadsApiService.fetchStates(token: authController.token.value);
      if (response['status'] == 'success') {
        final stateList = response['data'] ?? [];
        final uniqueStates = <String, Map<String, dynamic>>{};
        for (var state in stateList) {
          final title = state['state_title']?.toString() ?? '';
          final id = state['state_id'];
          if (title.isNotEmpty && id != null) {
            uniqueStates[title] = state;
          }
        }
        availableStates.assignAll(uniqueStates.keys.toList());
        stateIdMap.assignAll({
          for (var state in uniqueStates.values)
            state['state_title'].toString():
                int.parse(state['state_id'].toString())
        });
        selectedState.value = '';
        setupWatchers();
      } else {
        Get.snackbar('Error', 'Failed to fetch states: ${response['message']}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch states: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchDistricts() async {
    if (!stateIdMap.containsKey(selectedState.value)) return;
    try {
      isFetching.value = true;
      final stateId = stateIdMap[selectedState.value]!;
      final response = await leadsApiService.fetchDistricts(stateId,
          token: authController.token.value);
      if (response['status'] == 'success') {
        final districtList = response['data'] ?? [];
        final uniqueDistricts = <String, Map<String, dynamic>>{};
        for (var district in districtList) {
          final title = district['district_title']?.toString() ?? '';
          final id = district['districtid'];
          if (title.isNotEmpty && id != null) {
            uniqueDistricts[title] = district;
          }
        }
        availableDistricts.assignAll(uniqueDistricts.keys.toList());
        districtIdMap.assignAll({
          for (var district in uniqueDistricts.values)
            district['district_title'].toString():
                int.parse(district['districtid'].toString())
        });
        if (!availableDistricts.contains(selectedDistrict.value)) {
          selectedDistrict.value = '';
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch districts: ${response['message']}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch districts: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchCities() async {
    if (!districtIdMap.containsKey(selectedDistrict.value)) return;
    try {
      isFetching.value = true;
      final districtId = districtIdMap[selectedDistrict.value]!;
      final response = await leadsApiService.fetchCities(districtId,
          token: authController.token.value);
      if (response['status'] == 'success') {
        final cityList = response['data'] ?? [];
        final uniqueCities = <String, Map<String, dynamic>>{};
        for (var city in cityList) {
          final title = city['name']?.toString() ?? '';
          final id = city['id'];
          if (title.isNotEmpty && id != null) {
            uniqueCities[title] = city;
          }
        }
        availableCities.assignAll(uniqueCities.keys.toList());
        cityIdMap.assignAll({
          for (var city in uniqueCities.values)
            city['name'].toString(): int.parse(city['id'].toString())
        });
        if (!availableCities.contains(selectedCity.value)) {
          selectedCity.value = '';
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch cities: ${response['message']}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cities: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> createLead() async {
    isLoading.value = true;

    try {
      Map<String, dynamic> body = {
        "lead_type": leadTypeValue.value,
        "status": "pending",
        "team_lead_id": authController.userData['team_lead_id'].toString(),
      };

      final leadType = leadTypeValue.value;

      if (leadType == 'personal_loan' || leadType == 'home_loan') {
        body.addAll({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "state": selectedState.value,
          "district": selectedDistrict.value,
          "city": selectedCity.value,
          "company_name": companyNameController.text.trim(),
          "lead_amount":
              (double.tryParse(leadAmountController.text) ?? 0.0).toString(),
          "salary": (double.tryParse(salaryController.text) ?? 0.0).toString(),
          "success_percentage":
              (int.tryParse(selectedSuccessRatio.value) ?? 0).toString(),
          "expected_month": selectedMonth.value,
          "remarks": remarksController.text.trim(),
        });

        if (selectedDate.value != null) {
          body["dob"] = DateFormat("yyyy-MM-dd").format(selectedDate.value!);
        }
      } else if (leadType == 'business_loan') {
        body.addAll({
          "business_name": companyNameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "state": selectedState.value,
          "district": selectedDistrict.value,
          "city": selectedCity.value,
          "lead_amount":
              (double.tryParse(leadAmountController.text) ?? 0.0).toString(),
          "turnover_amount":
              (double.tryParse(salaryController.text) ?? 0.0).toString(),
          "business_budget":
              (double.tryParse(businessBudgetController.text) ?? 0.0)
                  .toString(),
          "it_return": itReturnController.text.trim(),
          "vintage_year":
              selectedVintageYear.value, // New field, parsed as integer
          "expected_month": selectedMonth.value,
          "success_percentage":
              (int.tryParse(selectedSuccessRatio.value) ?? 0).toString(),
          "remarks": remarksController.text.trim(),
        });
      } else if (leadType == 'creditcard_loan') {
        body.addAll({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "bank_names": selectedBanks.toList(),
        });
      } else if (leadType == 'future_lead') {
        body.addAll({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "location": locationController.text.trim()
        });
      }

      print("Sending lead data: $body");

      final response = await ApiService().createLead(
        token: authController.token.value,
        leadData: body,
        filePath: voiceRecorderController.recordedFilePath.toString(),
      );

      Get.snackbar("Success", response['message'],
          backgroundColor: Colors.green, colorText: Colors.white);

      clearForm(leadType: leadTypeValue.value);
      if (leadType == 'future_lead') {
        Get.snackbar('Success', 'Future Leads Saved');
      } else {
        Get.toNamed(
            AppRoutes.leadSavedSuccess); // 👈 default lead success screen
      }
      allLeadsController.fetchAllLeads();
      dashboardController.loadDashboardData();
    } catch (e) {
      print("Error during createLead: $e");
      Get.snackbar("Error", "Failed to save lead: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm({String leadType = 'personal_loan'}) {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    locationController.clear();
    companyNameController.clear();
    leadAmountController.clear();
    salaryController.clear();
    businessBudgetController.clear();
    itReturnController.clear();
    businessVintageController.clear(); // Clear new field
    remarksController.clear();
    selectedDate.value = null;
    selectedSuccessRatio.value = '';
    leadTypeValue.value = leadType;
    selectedMonth.value = '';
    selectedLocation.value = '';
    voiceFilePath.value = '';
    voiceRecorderController.onClose(); // Clear recorded file path if needed
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    companyNameController.dispose();
    selectedState.close();
    leadAmountController.dispose();
    salaryController.dispose();
    businessBudgetController.dispose();
    itReturnController.dispose();
    businessVintageController.dispose(); // Dispose new controller
    remarksController.dispose();
    super.onClose();
  }
}
