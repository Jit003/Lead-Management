import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' as getx;
import '../constant/api_url.dart';
import '../models/attendance_history_model.dart';

class AttendanceHistoryApiService extends getx.GetxService {

  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
    };
  }

  Future<AttendanceHistoryResponse> getAttendanceHistory({
    required String token,
  }) async {
    try {
      final uri = Uri.parse('${ApiUrl.baseUrl}/api/attendances');

      print('Making attendance history request to: $uri');
      print('Token: $token');

      final response = await http.get(
        uri,
        headers: _getHeaders(token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('Attendance history response status: ${response.statusCode}');
      print('Attendance history response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return AttendanceHistoryResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch attendance history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAttendanceHistory: $e');
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: Please check your internet connection');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid response format from server');
      } else {
        throw Exception('Failed to fetch attendance history: $e');
      }
    }
  }
}
