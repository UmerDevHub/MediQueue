import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_api_service.dart';
import 'user_home_provider.dart';

class AppointmentsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final UserApiService _apiService;

  AppointmentsNotifier(this._apiService) : super([]) {
    loadAppointments();
  }

  /// Load appointments from local storage or pre-populate with mockup values.
  Future<void> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('my_appointments');
    if (data != null) {
      final list = List<Map<String, dynamic>>.from(jsonDecode(data));
      state = list;
    } else {
      // Default realistic appointments for presentation
      final mock = [
        {
          'id': 'mock-appt-1',
          'status': 'booked',
          'doctor': {
            'name': 'Dr. Aisha Khan',
            'specialization': 'Pediatrics',
            'hospital_name': 'Mayo Clinic',
            'hospital_id': '451be8c9-76d0-4d51-9311-574211a76f62',
          },
          'slot': {
            'start_time': DateTime.now().add(const Duration(days: 1, hours: 2)).toIso8601String(),
          }
        },
        {
          'id': 'mock-appt-2',
          'status': 'completed',
          'doctor': {
            'name': 'Dr. Zain Malik',
            'specialization': 'Cardiology',
            'hospital_name': 'Shifa International',
            'hospital_id': 'd62cf9b1-0e10-410a-b32c-806734c2ab1e',
          },
          'slot': {
            'start_time': DateTime.now().subtract(const Duration(days: 3, hours: 1)).toIso8601String(),
          }
        }
      ];
      state = mock;
      await _saveLocal(mock);
    }
  }

  /// Adds a newly booked appointment to the top of the list.
  Future<void> addAppointment(Map<String, dynamic> appointment) async {
    final updated = [appointment, ...state];
    state = updated;
    await _saveLocal(updated);
  }

  /// Cancels an appointment. Real appointments are cancelled on the backend,
  /// while local state is updated to 'cancelled'.
  Future<void> cancelAppointment(String appointmentId) async {
    if (!appointmentId.startsWith('mock-')) {
      try {
        await _apiService.cancelAppointment(appointmentId);
      } catch (_) {
        // Continue to cancel locally even if backend fails (best effort)
      }
    }

    final updated = state.map((appt) {
      if (appt['id'] == appointmentId) {
        return {
          ...appt,
          'status': 'cancelled',
        };
      }
      return appt;
    }).toList();

    state = updated;
    await _saveLocal(updated);
  }

  Future<void> _saveLocal(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_appointments', jsonEncode(list));
  }
}

final appointmentsProvider = StateNotifierProvider<AppointmentsNotifier, List<Map<String, dynamic>>>((ref) {
  final apiService = ref.watch(userApiServiceProvider);
  return AppointmentsNotifier(apiService);
});
