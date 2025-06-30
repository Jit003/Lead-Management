import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import '../controller/attendance_controller.dart';
import 'camera_capture_screen.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Attendance',showBackButton: false,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.attendanceStatus.value;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data?.message ?? 'No status'),
            Text(data?.status ?? 'No status'),
            Text(data?.checkInTime ?? 'No status'),


            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final coordinates = await controller.getCurrentCoordinates();
                if (coordinates == null) {
                  Get.snackbar("Error", "Could not fetch coordinates");
                  return;
                }
                // Go to camera screen and wait for image to be captured
                await Get.to(() => CameraCaptureScreen());

                final imageFile = controller.getCapturedImageFile();

                if (imageFile == null) {
                  Get.snackbar("Error", "No image captured");
                  return;
                }

                if (data?.buttonAction == 'checkin') {
                  controller.performCheckIn(
                    coordinates:coordinates,
                    location: 'Nexpro Solution Office',
                    notes: 'Morning check-in',
                    image: imageFile,
                  );
                } else if (data?.buttonAction == 'checkout') {
                  controller.performCheckOut(
                    id: controller.checkInId.value,
                    coordinates: '20.292776,85.865974',
                    location: 'Main Office',
                    notes: 'Evening check-out',
                    image: imageFile,
                  );
                }
              },
              child: Text(data?.buttonAction?.toUpperCase() ?? 'LOADING'),
            ),
          ],
        );
      }),
    );
  }
}
