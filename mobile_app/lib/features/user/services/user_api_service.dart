import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config.dart';

class UserApiService {
  final String? token;

  UserApiService({required this.token});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Fetch ranked nearby hospitals based on user lat/lng.
  Future<List<Map<String, dynamic>>> getNearbyHospitals(double lat, double lng) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/hospitals/nearby?lat=$lat&lng=$lng');
    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['hospitals'] ?? []);
      } else {
        final detail = jsonDecode(response.body)['detail'] ?? 'Failed to load hospitals';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to connect to the hospital service: $e');
    }
  }

  /// Search doctors with optional specialization filter.
  Future<List<Map<String, dynamic>>> searchDoctors({String? specialization}) async {
    final filter = specialization != null && specialization.isNotEmpty
        ? '?specialization=${Uri.encodeComponent(specialization)}'
        : '';
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/appointments/doctors$filter');
    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final detail = jsonDecode(response.body)['detail'] ?? 'Failed to search doctors';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }
}
