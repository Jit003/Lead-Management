import 'package:get/get.dart';
import '../models/credit_card_model.dart';
import '../services/credit_card_api_service.dart';
import 'login-controller.dart';

class CreditLeadsController extends GetxController {
  var isLoading = false.obs;
  var leads = <Lead>[].obs;
  var errorMessage = ''.obs;
  final AuthController authController = Get.find<AuthController>();


  @override
  void onInit() {
    super.onInit();
    fetchCreditCardLeads();
  }

  Future<void> fetchCreditCardLeads() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.getCreditCardLeads(
        authController.token.value
      );
      leads.value = response.data.leads;
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

  Future<void> refreshLeads() async {
    await fetchCreditCardLeads();
  }

  Lead? getLeadById(int id) {
    try {
      return leads.firstWhere((lead) => lead.id == id);
    } catch (e) {
      return null;
    }
  }
}