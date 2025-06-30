import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kredipal/models/salary_slip_model.dart';
import 'package:path_provider/path_provider.dart';

import '../constant/api_url.dart';
import '../models/all_leads_model.dart';
import '../models/all_leaves_model.dart';
import '../models/all_task_model.dart';
import '../models/apply_leave_model.dart';
import '../models/credit_card_model.dart';

class ApiService {
  Future<Map<String, dynamic>> logIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiUrl.baseUrl}/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('the login issue is ${e.toString()}');
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/api/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiUrl.baseUrl}/api/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
      }),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return {
        'success': true,
        'message': data['message'],
        'user': data['user'],
        'profile_photo_url': data['profile_photo_url'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Profile update failed',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfilePhoto(
      File file, String token) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiUrl.baseUrl}/api/profile/photo'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('profile_photo', file.path));

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 422) {
      final resString = await response.stream.bytesToString();
      return jsonDecode(resString);
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse(
        "${ApiUrl.baseUrl}/api/change-password"); // Adjust endpoint if needed

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return {'success': true, 'message': data['message']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Something went wrong'
      };
    }
  }

  Future<Map<String, dynamic>> createLead({
    required String token,
    required Map<String, dynamic> leadData,
    String? filePath,
  }) async {
    var uri = Uri.parse('${ApiUrl.baseUrl}/api/leads');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    leadData.forEach((key, value) {
      if (key == 'bank_names') {
        // Expecting value to be a List directly
        List bankList = value is String ? jsonDecode(value) : value;
        for (var item in bankList) {
          request.fields['bank_names[]_${bankList.indexOf(item)}'] = item.toString();
        }

      } else {
        request.fields[key] = value.toString();
      }
    });

    print("🔍 Multipart fields being sent:");
    request.fields.forEach((key, value) {
      print("$key => $value");
    });

    if (filePath != null && File(filePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath(
        'voice_recording',
        filePath,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to create lead: ${response.statusCode} - ${response.body}');
    }
  }


  Future<AllLeadsList> fetchAllLeads({required String token}) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/api/leads'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('${response.body}');
      return AllLeadsList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch leads');
    }
  }

  static Future<Map<String, dynamic>> markAttendanceCheckIn({
    required String token,
    required String checkinImage,
    required String location,
    required String coordinates,
    required String notes,
  }) async {
    var uri = Uri.parse("${ApiUrl.baseUrl}/api/attendances");

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['location'] = location;
    request.fields['coordinates'] = coordinates;
    request.fields['notes'] = notes;

    // Attach image
    request.files
        .add(await http.MultipartFile.fromPath('checkin_image', checkinImage));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print('the checkin msg is ${response.body}');

    if (response.statusCode == 200) {
      return {
        'status': 'success',
        'message': 'Checked in successfully',
      };
    } else {
      return {
        'status': 'error',
        'message': 'Check-in failed: ${response.body}',
      };
    }
  }

  // Get all tasks
  Future<List<Task>> getTasks(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/api/tasks'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          final List<dynamic> tasksJson = jsonData['data'];
          return tasksJson.map((json) => Task.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load tasks: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Update task status and progress

  static Future<bool> updateTask(
      String taskId, Map<String, dynamic> body, String token) async {
    final url = Uri.parse('${ApiUrl.baseUrl}/api/tasks/$taskId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // 👈 Add this
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('the task edit ${response.body}');
      return true;
    } else {
      print("Update failed: ${response.body}");
      return false;
    }
  }

  static Future<AllLeavesModel?> getAllLeave(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/api/leaves'),
        headers: {'Authorization': "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('the all leaves data is ${response.body}');
        return AllLeavesModel.fromJson(body);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Future<ApplyLeaveResponse?> applyLeave({
    required String token,
    required String leaveType,
    required int appliedTo,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}/api/leaves');
      final body = {
        "leave_type": leaveType,
        "applied_to": appliedTo,
        "start_date": startDate,
        "end_date": endDate,
        "reason": reason,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("Apply Leave Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApplyLeaveResponse.fromJson(data);
      } else {
        print("Error while applying leave: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception during applyLeave: $e");
      return null;
    }
  }

  static Future<SalarySlipModel?> getSalarySlip(String token)async{
    try{

      final response = await http.get(Uri.parse('${ApiUrl.baseUrl}/api/salary-slips'),headers: {
        'Authorization':'Bearer $token'
      });

      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        print('the salary slip ${response.body}');
        return SalarySlipModel.fromJson(body);
      }

    }catch(e){
      print('the error in salary slip is ${e.toString()}');
    }
    return null;
  }


  static Future<void> downloadSalarySlip(String token, int slipId) async {
    try {
      final url = "https://crm.kredipal.com/api/salary-slips/$slipId/download";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200 && contentType.contains("application/pdf")) {
        final bytes = response.bodyBytes;

        // ✅ This directory works without permissions
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/salary_slip_$slipId.pdf";

        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print("File downloaded to $filePath");
      }
      else if (contentType.contains("application/json")) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      }
      else {
        throw Exception("Unexpected response: ${response.statusCode}");
      }
    } catch (e) {
      print("Download error: $e");
      rethrow;
    }
  }




}
