import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kredipal/controller/login-controller.dart';
import '../models/attendance_history_model.dart';
import '../services/attendance_history_api_services.dart';

class AttendanceHistoryController extends GetxController {
  final AttendanceHistoryApiService _apiService =
  Get.put(AttendanceHistoryApiService());
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  final Rx<AttendanceSummary?> summary = Rx<AttendanceSummary?>(null);
  final RxList<AttendanceRecord> records = <AttendanceRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedFilter = 'all'.obs;

  // Filtered records based on selected filter
  List<AttendanceRecord> get filteredRecords {
    switch (selectedFilter.value) {
      case 'completed':
        return records.where((record) => record.checkOut != null).toList();
      case 'incomplete':
        return records.where((record) => record.checkOut == null).toList();
      default:
        return records;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceHistory();
  }

  Future<void> fetchAttendanceHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (authController.token.value.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      print(
          'Fetching attendance history with token: ${authController.token.value}');
      final response = await _apiService.getAttendanceHistory(
          token: authController.token.value);

      if (response.status == 'success') {
        // Sanitize records to handle potentially invalid image URLs
        final sanitizedRecords = response.records.map((record) {
          return AttendanceRecord(
            employeeName: record.employeeName,
            date: record.date,
            checkIn: record.checkIn,
            checkOut: record.checkOut,
            checkInLocation: record.checkInLocation,
            checkOutLocation: record.checkOutLocation,
            checkInCoordinates: record.checkInCoordinates,
            checkOutCoordinates: record.checkOutCoordinates,
            notes: record.notes,
            checkinImage: _validateImageUrl(record.checkinImage) ?? '',
            checkoutImage: _validateImageUrl(record.checkoutImage),
            workedHours: record.workedHours,
          );
        }).toList();

        summary.value = response.summary;
        records.assignAll(sanitizedRecords);
      } else {
        throw Exception(
            'Failed to fetch attendance history: ${response.status}');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate and sanitize image URLs
  String? _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    // Check if the URL is valid (has http or https scheme)
    if (Uri.tryParse(url)?.hasScheme ?? false) {
      return url;
    }
    return null;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String formatDateWithDay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      String weekday = weekdays[date.weekday - 1];
      return '$weekday, ${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String calculateWorkTime(String? checkIn, String? checkOut) {
    if (checkIn == null ||
        checkOut == null ||
        checkIn.isEmpty ||
        checkOut.isEmpty) {
      return '--:--';
    }

    try {
      DateTime checkInTime = DateTime.parse(checkIn);
      DateTime checkOutTime = DateTime.parse(checkOut);

      Duration difference = checkOutTime.difference(checkInTime);
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);

      return '${hours}h ${minutes}m';
    } catch (e) {
      return '--:--';
    }
  }

  Color getStatusColor(AttendanceRecord record) {
    if (record.checkOut != null && record.checkOut!.isNotEmpty) {
      return const Color(0xFF27AE60); // Green for completed
    } else {
      return const Color(0xFFE67E22); // Orange for incomplete
    }
  }

  String getStatusText(AttendanceRecord record) {
    return record.checkOut != null && record.checkOut!.isNotEmpty
        ? 'COMPLETED'
        : 'INCOMPLETE';
  }

  double getAttendancePercentage() {
    if (summary.value == null ||
        summary.value!.totalDays == null ||
        summary.value!.totalDays == 0) {
      return 0.0;
    }
    return (summary.value!.present! / summary.value!.totalDays! * 100)
        .clamp(0.0, 100.0);
  }
}