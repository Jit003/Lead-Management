import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kredipal/constant/api_url.dart';

import '../models/credit_card_model.dart';

class ApiService {

  static Future<LeadsResponse> getCreditCardLeads(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/api/leads?lead_type=creditcard_loan'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('the credit card leads are ${response.body}');
        return LeadsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load leads: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching leads: $e');
    }
  }
}