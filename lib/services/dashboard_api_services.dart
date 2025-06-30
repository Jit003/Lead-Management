import 'package:http/http.dart' as http;
import 'package:kredipal/constant/api_url.dart';
import 'dart:convert';
import '../models/dashboard_model.dart';

class DashboardApiService {
  Future<DashboardModel> fetchDashboardData({
    required String token,
    required String expectedMonth,
    required String leadType,
  }) async {
    final queryParameters = {
      'expected_month': expectedMonth,
      'lead_type': leadType,
    };

    final url = Uri.parse('${ApiUrl.baseUrl}/api/dashboard')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Sending expectedMonth: $expectedMonth, leadType: $leadType");
      print("URL: $url");
      print("Response: ${response.body}");
      return DashboardModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load filtered dashboard');
    }
  }
}