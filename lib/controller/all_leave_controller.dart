import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/services/api_services.dart';
import '../models/all_leaves_model.dart';

class AllLeavesController extends GetxController {
  var isLoading = false.obs;
  var leavesList = <Leaves>[].obs;

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit(){
    getAllLeaves();
    super.onInit();
  }

  Future<void> getAllLeaves() async {
    try {
      isLoading(true);

      final leavesModel = await ApiService.getAllLeave(authController.token.value);

      if (leavesModel != null && leavesModel.leaves != null) {
        leavesList.assignAll(leavesModel.leaves!);
      } else {
        leavesList.clear();
      }
    } catch (e) {
      print("Error fetching leaves: $e");
    } finally {
      isLoading(false);
    }
  }
}
