import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/attendance_status_model.dart';
import '../services/attendance_api_service.dart';
import '../services/location_service.dart';
import 'login-controller.dart'; // Assume you already have this

class AttendanceController extends GetxController {
  final AttendanceApiService apiService = AttendanceApiService();
  final AuthController authController = Get.find<AuthController>();

  Rx<AttendanceStatus?> attendanceStatus = Rx<AttendanceStatus?>(null);
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  RxBool isSessionExpanded = false.obs;



  RxInt checkInId = 0.obs;

  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  XFile? capturedImage;

  List<CameraDescription> cameras = [];

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceStatus();
    initCamera();
  }

  var countdown = 5.obs;
  var isCapturing = false.obs;

  Future<void> startCountdownAndCapture() async {
    isCapturing.value = true;
    countdown.value = 5;

    for (int i = 5; i > 0; i--) {
      countdown.value = i;
      await Future.delayed(const Duration(seconds: 1));
    }

    await captureImage();
    Get.back(); // return to previous screen after capture
    isCapturing.value = false;
  }



  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      print('Camera error: $e');
    }
  }


  Future<void> captureImage() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    try {
      capturedImage = await cameraController!.takePicture();
    } catch (e) {
      print('Capture error: $e');
    }
  }

  File? getCapturedImageFile() {
    return capturedImage != null ? File(capturedImage!.path) : null;
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<String?> getCurrentCoordinates() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        final latitude = position.latitude.toStringAsFixed(6);
        final longitude = position.longitude.toStringAsFixed(6);
        final formatted = '$latitude,$longitude';
        print('📍 Formatted Coordinates: $formatted');
        return formatted;
      }
    } catch (e) {
      print('Location error: $e');
    }
    return null;
  }



  Future<void> fetchAttendanceStatus() async {
    isLoading.value = true;
    final token = authController.token.value;

    final result = await apiService.fetchStatus(token);
    print('the attendance status is $result');
    if (result != null) {
      attendanceStatus.value = result;
      // ✅ Set check-in ID from status if available
      if (result.attendanceId != null) {
        checkInId.value = result.attendanceId!;
        print("✅ Fetched check-in ID from status: ${checkInId.value}");
      }
    }
    isLoading.value = false;
  }

  Future<void> performCheckIn({
    required String coordinates,
    required String location,
    required String notes,
    File? image,
  }) async {
    isLoading.value = true;

    final response = await apiService.checkIn(
      authController.token.value,
      {
        'check_in_coordinates': coordinates,
        'check_in_location': location,
        'notes': notes,
      },
      image,
    );

    if (response != null && response['status'] == 'success') {
      print('✅ Check-in ID received: ${response['data']['id']}');

      await fetchAttendanceStatus();
      Get.snackbar('Success','checkin',backgroundColor: Colors.green);
    }

    isLoading.value = false;
  }

  Future<void> performCheckOut({
    required int id,
    required String coordinates,
    required String location,
    required String notes,
    File? image,
  }) async {
    isLoading.value = true;

    print("📤 Attempting checkout with ID: $id");
    print("📤 Coordinates: $coordinates");
    print("📤 Location: $location");


    final response = await apiService.checkOut(
      authController.token.value,
      id,
      {
        'check_out_coordinates': coordinates,
        'check_out_location': location,
        'notes': notes,
      },
      image,
    );

    if (response != null && response['status'] == 'success') {
      checkInId.value = 0;
      await fetchAttendanceStatus();
      Get.snackbar('Success','checkOut',backgroundColor: Colors.green);
    }

    isLoading.value = false;
  }


  String formatTime(String? rawDateTime) {
    if (rawDateTime == null) return '--:--';
    try {
      final dt = DateTime.parse(rawDateTime).toLocal(); // Convert to local time
      return DateFormat('hh:mm').format(dt); // Example: 07:06 AM
    } catch (e) {
      return '--:--';
    }
  }


}
