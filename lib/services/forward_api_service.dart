import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kredipal/constant/api_url.dart';
import 'package:http/http.dart' as http;
import '../controller/login-controller.dart';

class ForwardApiService {
  static final Dio _dio = Dio();
  static final _authController = Get.find<AuthController>();

  static Future<Map<String, dynamic>> forwardLead({
    required int leadId,
    required int forwardToId,
    required String forwardNotes,
  }) async {
    final String token = _authController.token.value;

    try {
      final response = await _dio.post(
        '${ApiUrl.baseUrl}/api/leads/$leadId/forward',
        data: {
          'forward_to': forwardToId,
          'forward_notes': forwardNotes,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Lead forwarded successfully',
      };
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Failed to forward lead';
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  static Future<Map<String, dynamic>?> getForwardStatus(int leadId) async {
    final url = Uri.parse('https://crm.kredipal.com/api/leads/$leadId/forward-status');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${_authController.token.value}'},
    );

    if (response.statusCode == 200) {
      print('the forward response is ${response.body}');
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }
}
