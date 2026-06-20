import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config.dart';

/// Custom exception for authentication and API related errors.
class AuthApiException implements Exception {
  final String message;
  final int? statusCode;

  AuthApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class AuthApiService {
  /// Calls POST /api/v1/auth/signup to register a new user.
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'user',
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/auth/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return responseBody;
      } else {
        final message = responseBody['detail'] ?? 'Registration failed';
        throw AuthApiException(_parseDetailMessage(message), statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Network error: Could not reach the server. Please check your internet connection.');
    }
  }

  /// Calls POST /api/v1/auth/login to authenticate an existing user.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        final message = responseBody['detail'] ?? 'Authentication failed';
        throw AuthApiException(_parseDetailMessage(message), statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Network error: Could not reach the server. Please check your internet connection.');
    }
  }

  /// Normalizes validation errors if detail is a list of errors.
  String _parseDetailMessage(dynamic detail) {
    if (detail is String) return detail;
    if (detail is List) {
      try {
        final errors = detail.map((e) => e['msg'] ?? '').where((msg) => msg.isNotEmpty).toList();
        if (errors.isNotEmpty) {
          return errors.join(', ');
        }
      } catch (_) {}
    }
    return 'An unexpected validation error occurred.';
  }
}
