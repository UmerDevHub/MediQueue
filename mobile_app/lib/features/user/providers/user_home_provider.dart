import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../services/user_api_service.dart';

class UserHomeState {
  final List<Map<String, dynamic>> hospitals;
  final bool isLoadingHospitals;
  final String? hospitalError;

  final List<Map<String, dynamic>> doctors;
  final bool isLoadingDoctors;
  final String? doctorError;

  UserHomeState({
    required this.hospitals,
    required this.isLoadingHospitals,
    this.hospitalError,
    required this.doctors,
    required this.isLoadingDoctors,
    this.doctorError,
  });

  factory UserHomeState.initial() => UserHomeState(
        hospitals: [],
        isLoadingHospitals: false,
        doctors: [],
        isLoadingDoctors: false,
      );

  UserHomeState copyWith({
    List<Map<String, dynamic>>? hospitals,
    bool? isLoadingHospitals,
    String? hospitalError,
    List<Map<String, dynamic>>? doctors,
    bool? isLoadingDoctors,
    String? doctorError,
  }) {
    return UserHomeState(
      hospitals: hospitals ?? this.hospitals,
      isLoadingHospitals: isLoadingHospitals ?? this.isLoadingHospitals,
      hospitalError: hospitalError ?? this.hospitalError,
      doctors: doctors ?? this.doctors,
      isLoadingDoctors: isLoadingDoctors ?? this.isLoadingDoctors,
      doctorError: doctorError ?? this.doctorError,
    );
  }
}

class UserHomeNotifier extends StateNotifier<UserHomeState> {
  final UserApiService _apiService;

  UserHomeNotifier(this._apiService) : super(UserHomeState.initial()) {
    loadHomeData();
  }

  /// Load both hospitals and doctors in parallel.
  Future<void> loadHomeData() async {
    // Default coordinates: Lahore, Pakistan (31.5204, 74.3587)
    await Future.wait([
      fetchNearbyHospitals(31.5204, 74.3587),
      fetchDoctors(),
    ]);
  }

  /// Fetches nearby hospitals ranked by composite score.
  Future<void> fetchNearbyHospitals(double lat, double lng) async {
    state = state.copyWith(isLoadingHospitals: true, hospitalError: null);
    try {
      final list = await _apiService.getNearbyHospitals(lat, lng);
      state = state.copyWith(isLoadingHospitals: false, hospitals: list);
    } catch (e) {
      state = state.copyWith(
        isLoadingHospitals: false,
        hospitalError: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Fetches doctors list, with optional specialization query.
  Future<void> fetchDoctors({String? specialization}) async {
    state = state.copyWith(isLoadingDoctors: true, doctorError: null);
    try {
      final list = await _apiService.searchDoctors(specialization: specialization);
      state = state.copyWith(isLoadingDoctors: false, doctors: list);
    } catch (e) {
      state = state.copyWith(
        isLoadingDoctors: false,
        doctorError: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final userApiServiceProvider = Provider<UserApiService>((ref) {
  final authState = ref.watch(authProvider);
  return UserApiService(token: authState.token);
});

final userHomeProvider = StateNotifierProvider<UserHomeNotifier, UserHomeState>((ref) {
  final apiService = ref.watch(userApiServiceProvider);
  return UserHomeNotifier(apiService);
});
