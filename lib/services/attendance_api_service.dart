import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constant/api_url.dart';
import '../models/attendance_status_model.dart';

class AttendanceApiService {

  Future<AttendanceStatus?> fetchStatus(String token) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/api/attendance/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('the attendance status is ${response.body}');

      return AttendanceStatus.fromJson(json.decode(response.body));
    } else {
      print("Error status: ${response.statusCode}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> checkIn(String token, Map<String, String> data, File? image) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiUrl.baseUrl}/api/attendances'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll(data);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('checkin_image', image.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      print('the check in data is ${response.body}');
      return json.decode(response.body);
    }
    print("Check-in error: ${response.statusCode}");
    print("Check-in error: ${response.body}");

    return null;
  }

  Future<Map<String, dynamic>?> checkOut(String token, int id, Map<String, String> data, File? image) async {
    final url = '${ApiUrl.baseUrl}/api/attendances/$id';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll(data);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('checkout_image', image.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      print('the check out data is ${response.body}');
      return json.decode(response.body);
    }
    print("Check-out error: ${response.statusCode}");
    print("Check-out error: ${response.body}");

    return null;
  }
}
