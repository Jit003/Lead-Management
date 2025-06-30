import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/models/salary_slip_model.dart';
import 'package:kredipal/services/api_services.dart';

class SalarySlipController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var isLoading = false.obs;
  var slipList = <Data>[].obs;

  @override
  void  onInit(){
    getSalarySlip();
    super.onInit();
  }

  Future<void> getSalarySlip() async {
    final response = await ApiService.getSalarySlip(authController.token.value);
    if (response != null) {
      return slipList.assignAll(response.data!);
    }
  }

  Future<void> downloadSlip(int slipId) async {
    try {
      isLoading(true);
      await ApiService.downloadSalarySlip(authController.token.value, slipId);
      Get.snackbar("Success", "Salary slip downloaded");
    } catch (e) {
      // Show backend error if available
      Get.snackbar("Error", e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }
}
