import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/attendance_controller.dart';

class CameraCaptureScreen extends StatelessWidget {
  final AttendanceController controller = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    // Start the countdown only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isCapturing.value) {
        controller.startCountdownAndCapture();
      }
    });

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: CustomAppBar(title: 'Capture the Photo'),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              '📸 Get ready!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              'Capturing in ${controller.countdown.value} seconds',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            )),
            const SizedBox(height: 30),
            Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(() => controller.countdown.value > 0
                ? Text(
              '${controller.countdown.value}',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            )
                : SizedBox.shrink()),
          ],
        );
      }),
    );
  }
}
