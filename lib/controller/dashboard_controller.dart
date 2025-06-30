import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_api_services.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  var dashboardData = DashboardModel().obs;
  var isLoading = true.obs;
  var selectedLeadType = 'all'.obs;
  var expectedMonth = DateFormat('MMMM').format(DateTime.now()).obs;

  final AuthController authController = Get.find<AuthController>();
  final DashboardApiService _apiService = DashboardApiService();

  @override
  void onInit() {
    if (authController.token.value.isNotEmpty) {
      loadDashboardData();

      // Refresh on leadType or expectedMonth change
      ever(selectedLeadType, (_) => loadDashboardData());
      ever(expectedMonth, (_) => loadDashboardData());
    }

    super.onInit();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading(true);

      final result = await _apiService.fetchDashboardData(
        token: authController.token.value,
        expectedMonth: expectedMonth.value,
        leadType: selectedLeadType.value,
      );

      dashboardData.value=result;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  String formatCurrency(dynamic amount) {
    if (amount == null) return '₹0';

    try {
      double value;

      if (amount is int) {
        value = amount.toDouble();
      } else if (amount is double) {
        value = amount;
      } else if (amount is String) {
        value = double.parse(amount);
      } else {
        return '₹0';
      }

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
}