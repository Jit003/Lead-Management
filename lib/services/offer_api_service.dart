import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:kredipal/constant/api_url.dart';

import '../controller/login-controller.dart';
import '../models/offer_model.dart';

class ApiService extends GetxService {

  // Get token from storage or auth controller
  String get authToken => Get.find<AuthController>().token.value;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
    'Accept': 'application/json',
  };

  Future<OffersModel?> getOffers({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (filter != null) queryParams['filter'] = filter;
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final uri = Uri.parse('${ApiUrl.baseUrl}/api/offers').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print('the offer is ${response.body}');
        final jsonData = json.decode(response.body);
        return OffersModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        print('the offer error is ${response.body}');
        // Handle unauthorized
        return null;
      } else {
        throw Exception('Failed to load offers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching offers: $e');
      return null;
    }
  }

}
