import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';
import 'package:kredipal/constant/api_url.dart';
import 'package:kredipal/controller/login-controller.dart';
import '../models/all_leads_model.dart';

class LeadsApiService extends getx.GetxService {
  late Dio _dio;
  AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Authorization': 'Bearer ${authController.token.value}'},

    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  Future<AllLeadsList> getAllLeads({
    String? leadType,
    String? status,
    String? dateFilter,
    String? expectedMonth,
    String? startDate, // Add this
    String? endDate,   // Add this
    String? search,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (leadType != null && leadType != 'All') {
        queryParams['lead_type'] = leadType;
      }
      if (status != null && status.toLowerCase() != 'all') {
        queryParams['status'] = status;
      }
      if (expectedMonth != null && expectedMonth != 'All') {
        queryParams['expected_month'] = expectedMonth;
      }

      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate; // Format: 'YYYY-MM-DD'
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      // Add date_filter only if date range is selected
      if ((startDate != null && startDate.isNotEmpty) &&
          (endDate != null && endDate.isNotEmpty)) {
        queryParams['date_filter'] = 'date_range';
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search; // ✅ Add this
      }

      final response = await _dio.get('/api/leads', queryParameters: queryParams);

      if (response.statusCode == 200) {
        return AllLeadsList.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch leads: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching leads: $e');
    }
  }

  Future<Leads> getLeadDetails(int leadId) async {
    try {
      final response = await _dio.get('/api/leads/$leadId');

      if (response.statusCode == 200) {
        return Leads.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch lead details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }



  // GET lead details for editing
  Future<Leads> getLeadForEdit(int leadId) async {
    try {
      final response = await _dio.get('/api/leads/$leadId/edit');
      if (response.statusCode == 200 &&
          response.data['status'] == 'success') {
        return Leads.fromJson(response.data['data']['lead']);
      } else {
        throw Exception('Failed to fetch lead: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching lead: $e');
    }
  }

  // PUT update lead
  Future<void> updateLead(int leadId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/leads/$leadId', data: data);
      if (response.statusCode != 200 || response.data['status'] != 'success') {
        print('Failed to update lead: ${response.data['message']}');
        throw Exception('Failed to update lead: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error updating lead: $e');
    }
  }

  Future<void> deleteLead(int leadId) async {
    try {
      final response = await _dio.delete('/api/leads/$leadId',);
      if (response.statusCode != 200 || response.data['status'] != 'success') {
        print('Failed to delete lead: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error updating lead: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStates({required String token}) async {
    try {
      print('fetchStates: Sending request with token: $token to ${ApiUrl.baseUrl}/api/states');
      final response = await _dio.get(
        '/api/states',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('fetchStates: Status: ${response.statusCode}, Response: ${response.data}');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data;
      }
      print('fetchStates: Failed with message: ${response.data['message'] ?? 'No message'}');
      throw Exception('Failed to fetch states: ${response.data['message'] ?? 'Unknown error'}');
    } on DioException catch (e) {
      print('fetchStates: DioException: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Error fetching states: ${e.message}');
    } catch (e) {
      print('fetchStates: Error: $e');
      throw Exception('Error fetching states: $e');
    }
  }
  Future<Map<String, dynamic>> fetchDistricts(int stateId, {required String token}) async {
    try {
      print('fetchDistricts: Sending request for stateId: $stateId, token: $token to ${ApiUrl.baseUrl}/api/districts/$stateId');
      final response = await _dio.get(
        '/api/districts/$stateId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('fetchDistricts: Status: ${response.statusCode}, Response: ${response.data}');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data;
      }
      print('fetchDistricts: Failed with message: ${response.data['message'] ?? 'No message'}');
      throw Exception('Failed to fetch districts: ${response.data['message'] ?? 'Unknown error'}');
    } on DioException catch (e) {
      print('fetchDistricts: DioException: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Error fetching districts: ${e.message}');
    } catch (e) {
      print('fetchDistricts: Error: $e');
      throw Exception('Error fetching districts: $e');
    }
  }
  Future<Map<String, dynamic>> fetchCities(int districtId, {required String token}) async {
    try {
      print('fetchCities: Sending request for districtId: $districtId, token: $token to ${ApiUrl.baseUrl}/api/cities/$districtId');
      final response = await _dio.get(
        '/api/cities/$districtId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('fetchCities: Status: ${response.statusCode}, Response: ${response.data}'); // Debug log
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data;
      }
      print('fetchCities: Failed with message: ${response.data['message'] ?? 'No message'}'); // Debug log
      throw Exception('Failed to fetch cities: ${response.data['message'] ?? 'Unknown error'}');
    } on DioException catch (e) {
      print('fetchCities: DioException: ${e.message}, Response: ${e.response?.data}'); // Debug log
      throw Exception('Error fetching cities: ${e.message}');
    } catch (e) {
      print('fetchCities: Error: $e'); // Debug log
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<Map<String, dynamic>> createLead({
    required String token,
    required Map<String, dynamic> leadData,
    required String filePath,
  }) async {
    try {
      print('createLead: Token: $token, Data: $leadData, File: $filePath'); // Debug log
      final response = await _dio.post(
        '/api/leads',
        data: leadData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('createLead: Status: ${response.statusCode}, Response: ${response.data}'); // Debug log
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data;
      }
      throw Exception('Failed to create lead: ${response.data['message'] ?? 'Unknown error'}');
    } on DioException catch (e) {
      print('createLead: DioException: ${e.message}, Response: ${e.response?.data}'); // Debug log
      throw Exception('Error creating lead: ${e.message}');
    } catch (e) {
      print('createLead: Error: $e'); // Debug log
      throw Exception('Error creating lead: $e');
    }
  }
}

