import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../user/providers/user_home_provider.dart';

class EmergencyState {
  final String symptoms;
  final double severityScore;
  final bool ambulanceRequired;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? dispatchResult;

  EmergencyState({
    required this.symptoms,
    required this.severityScore,
    required this.ambulanceRequired,
    required this.isLoading,
    this.error,
    this.dispatchResult,
  });

  factory EmergencyState.initial() => EmergencyState(
        symptoms: '',
        severityScore: 5.0,
        ambulanceRequired: false,
        isLoading: false,
      );

  EmergencyState copyWith({
    String? symptoms,
    double? severityScore,
    bool? ambulanceRequired,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? dispatchResult,
  }) {
    return EmergencyState(
      symptoms: symptoms ?? this.symptoms,
      severityScore: severityScore ?? this.severityScore,
      ambulanceRequired: ambulanceRequired ?? this.ambulanceRequired,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      dispatchResult: dispatchResult ?? this.dispatchResult,
    );
  }
}

class EmergencyNotifier extends StateNotifier<EmergencyState> {
  final Ref _ref;

  EmergencyNotifier(this._ref) : super(EmergencyState.initial());

  void setSymptoms(String val) {
    state = state.copyWith(symptoms: val);
  }

  void setSeverityScore(double val) {
    state = state.copyWith(severityScore: val);
  }

  void setAmbulanceRequired(bool val) {
    state = state.copyWith(ambulanceRequired: val);
  }

  void reset() {
    state = EmergencyState.initial();
  }

  /// Triggers the emergency dispatch API call on the backend.
  Future<bool> triggerEmergency({required String userId}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Default coordinates: Lahore, Pakistan
    const double lat = 31.5204;
    const double lng = 74.3587;

    try {
      final apiService = _ref.read(userApiServiceProvider);
      final result = await apiService.dispatchEmergency(
        userId: userId,
        symptoms: state.symptoms.isNotEmpty ? state.symptoms : 'Unspecified Acute Symptoms',
        severityScore: state.severityScore,
        lat: lat,
        lng: lng,
        ambulanceRequired: state.ambulanceRequired,
      );

      state = state.copyWith(isLoading: false, dispatchResult: result);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}

final emergencyProvider = StateNotifierProvider<EmergencyNotifier, EmergencyState>((ref) {
  return EmergencyNotifier(ref);
});
