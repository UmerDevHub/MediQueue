import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_api_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}

class AuthState {
  final AuthStatus status;
  final String? token;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.token,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _apiService = AuthApiService();

  AuthNotifier() : super(AuthState.initial()) {
    _tryAutoLogin();
  }

  /// Tries to load existing session from local storage.
  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user_profile');

    if (token != null && token.isNotEmpty && userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        state = AuthState(
          status: AuthStatus.authenticated,
          token: token,
          user: UserModel.fromJson(userMap),
        );
      } catch (_) {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Authenticate and retrieve token.
  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final data = await _apiService.login(email: email, password: password);
      final token = data['access_token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userMap);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user_profile', jsonEncode(userModel.toJson()));

      state = AuthState(
        status: AuthStatus.authenticated,
        token: token,
        user: userModel,
      );
      return true;
    } on AuthApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred during login. Please try again.',
      );
      return false;
    }
  }

  /// Register and perform auto-login.
  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Create user account
      await _apiService.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: 'user', // Default is patient
      );

      // Log in automatically after registration
      return await login(email, password);
    } on AuthApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred during signup. Please try again.',
      );
      return false;
    }
  }

  /// Terminate session and clear storage.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_profile');
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
