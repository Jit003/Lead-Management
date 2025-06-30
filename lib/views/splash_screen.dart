import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/controller/login-controller.dart';
import 'package:kredipal/controller/splash-controller.dart';
import 'package:video_player/video_player.dart';



class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
     return   Scaffold(
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SizedBox(
              width: controller.videoController.value.size.width,
              height: controller.videoController.value.size.height,
              child: VideoPlayer(controller.videoController),
            ),
          ],
        );
      }),
    );
  }
}
