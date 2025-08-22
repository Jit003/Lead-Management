import 'package:get/get.dart';
import 'package:kredipal/constant/app_images.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/routes/app_routes.dart';
import 'package:kredipal/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoController;
  var isInitialized = false.obs;

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

    isInitialized.value = true;
    navigateToNext();
  }

  void navigateToNext() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      authController.token.value = token;
      print('the splash screen token is $token');

      try {
        final profile = await ApiService.getUserProfile(token);
        authController.userData.value = profile;

        Get.offAllNamed(AppRoutes.home); // ✅ Go to home
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch user profile');
        Get.offAllNamed(AppRoutes.login); // If API fails, fallback to login
      }
    } else {
      Get.offAllNamed(AppRoutes.login); // ❌ No token, go to login
    }
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
