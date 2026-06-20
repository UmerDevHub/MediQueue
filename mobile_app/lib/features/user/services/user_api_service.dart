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

  /// Get available slots for a specific doctor.
  Future<List<Map<String, dynamic>>> getDoctorSlots(String doctorId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/appointments/doctors/$doctorId/slots');
    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final detail = jsonDecode(response.body)['detail'] ?? 'Failed to load slots';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to load slots: $e');
    }
  }

  /// Book an appointment.
  Future<Map<String, dynamic>> bookAppointment({
    required String userId,
    required String doctorId,
    required String slotId,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/appointments/book');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'user_id': userId,
          'doctor_id': doctorId,
          'slot_id': slotId,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return responseBody;
      } else {
        final detail = responseBody['detail'] ?? 'Booking failed';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  /// Cancel an appointment.
  Future<Map<String, dynamic>> cancelAppointment(String appointmentId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/appointments/$appointmentId/cancel');
    try {
      final response = await http.patch(url, headers: _headers);

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        final detail = responseBody['detail'] ?? 'Cancellation failed';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  /// Get live wait-time analytics for a hospital.
  Future<Map<String, dynamic>> getHospitalWaitTime(String hospitalId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/hospitals/$hospitalId/wait-time');
    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final detail = jsonDecode(response.body)['detail'] ?? 'Failed to load wait time';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Failed to load wait time: $e');
    }
  }
}
