import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_home_provider.dart';

/// Holds the currently selected doctor details for booking.
final selectedDoctorProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Holds the currently selected slot details for booking.
final selectedSlotProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Holds the confirmed appointment details after a successful book transaction.
final confirmedAppointmentProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// FutureProvider that fetches available slots for the selected doctor.
final doctorSlotsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final selectedDoctor = ref.watch(selectedDoctorProvider);
  if (selectedDoctor == null) return [];
  final doctorId = selectedDoctor['id'] as String? ?? selectedDoctor['doctor_id'] as String? ?? '';
  if (doctorId.isEmpty) return [];
  final apiService = ref.watch(userApiServiceProvider);
  return await apiService.getDoctorSlots(doctorId);
});
