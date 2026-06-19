import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import '../features/auth/user_login/user_login_screen.dart';
import '../features/auth/user_signup/user_signup_screen.dart';
import '../features/auth/splash_screen/splash_screen.dart';
import '../features/auth/onboarding/onboarding_screen.dart';
import '../features/auth/role_selection/role_selection_screen.dart';

// Hospital Admin — all screens under features/hospital_admin/
import '../features/hospital_admin/login/hospital_admin_login_screen.dart';
import '../features/hospital_admin/dashboard/hospital_admin_dashboard_screen.dart';
import '../features/hospital_admin/live_queue/live_queue_management_screen.dart';
import '../features/hospital_admin/emergency_alert/incoming_emergency_alert_screen.dart';
import '../features/hospital_admin/doctors_on_duty/doctors_on_duty_screen.dart';

// Doctor — all screens under features/doctor/
import '../features/doctor/login/doctor_login_screen.dart';
import '../features/doctor/home/doctor_home_screen.dart';
import '../features/doctor/my_schedule/my_schedule_screen.dart';
import '../features/doctor/appointment_detail/appointment_detail_screen.dart';
import '../features/doctor/profile/doctor_profile_screen.dart';

// User / Patient
import '../features/user/home/user_home_screen.dart';
import '../features/user/appointments_home/appointments_home_screen.dart';
import '../features/user/doctor_detail/doctor_detail_screen.dart';
import '../features/user/booking_confirmation/booking_confirmation_screen.dart';
import '../features/user/my_appointments/my_appointments_screen.dart';
import '../features/user/notifications/notifications_screen.dart';
import '../features/user/profile/user_profile_screen.dart';

// Emergency
import '../features/emergency/emergency_trigger_screen.dart';
import '../features/emergency/emergency_dispatching_screen.dart';
import '../features/emergency/emergency_result_screen.dart';

// Live Queue
import '../features/live_queue/live_queue_tracker_screen.dart';

// ---------------------------------------------------------------------------
// Auth state helpers
// ---------------------------------------------------------------------------

Future<bool> _isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return (prefs.getString('token') ?? '').isNotEmpty;
}

Future<bool> _hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('seen_onboarding') ?? false;
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final loggedIn = await _isLoggedIn();
    final seenOnboarding = await _hasSeenOnboarding();
    final loc = state.matchedLocation;

    final isSplash = loc == '/splash';
    final isOnboarding = loc == '/onboarding';
    final isAuthRoute = [
      '/user_login',
      '/signup',
      '/hospital_admin_login',
      '/doctor_login',
      '/role_selection',
    ].contains(loc);

    if (isSplash) return null;

    if (!seenOnboarding && !isOnboarding) return '/onboarding';

    if (!loggedIn && !isAuthRoute && !isOnboarding) return '/role_selection';

    if (loggedIn && isAuthRoute) return '/user_home';

    return null;
  },
  routes: [
    // ── Auth ────────────────────────────────────────────────────────────────
    GoRoute(path: '/splash',         builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding',     builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/role_selection', builder: (_, __) => const RoleSelectionScreen()),
    GoRoute(path: '/user_login',     builder: (_, __) => const UserLoginScreen()),
    GoRoute(path: '/signup',         builder: (_, __) => const UserSignupScreen()),

    // ── Hospital Admin ───────────────────────────────────────────────────────
    GoRoute(path: '/hospital_admin_login', builder: (_, __) => const HospitalAdminLoginScreen()),
    GoRoute(path: '/admin_home',           builder: (_, __) => const HospitalAdminDashboardScreen()),
    GoRoute(path: '/live_queue',           builder: (_, __) => const LiveQueueManagementScreen()),
    GoRoute(path: '/emergency_alert',      builder: (_, __) => const IncomingEmergencyAlertScreen()),
    GoRoute(path: '/doctors_on_duty',      builder: (_, __) => const DoctorsOnDutyScreen()),

    // ── Doctor ──────────────────────────────────────────────────────────────
    GoRoute(path: '/doctor_login',       builder: (_, __) => const DoctorLoginScreen()),
    GoRoute(path: '/doctor_home',        builder: (_, __) => const DoctorHomeScreen()),
    GoRoute(path: '/my_schedule',        builder: (_, __) => const MyScheduleScreen()),
    GoRoute(
      path: '/appointment_detail',
      builder: (_, state) => AppointmentDetailScreen(
        appointmentId: state.extra as String? ?? '',
      ),
    ),
    GoRoute(path: '/doctor_profile',     builder: (_, __) => const DoctorProfileScreen()),

    // ── User / Patient ───────────────────────────────────────────────────────
    GoRoute(path: '/user_home',           builder: (_, __) => const UserHomeScreen()),
    GoRoute(path: '/appointments_home',   builder: (_, __) => const AppointmentsHomeScreen()),
    GoRoute(path: '/doctor_detail',       builder: (_, __) => const DoctorDetailScreen()),
    GoRoute(path: '/booking_confirmation',builder: (_, __) => const BookingConfirmationScreen()),
    GoRoute(path: '/my_appointments',     builder: (_, __) => const MyAppointmentsScreen()),
    GoRoute(path: '/notifications',       builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/user_profile',        builder: (_, __) => const UserProfileScreen()),

    // ── Emergency ───────────────────────────────────────────────────────────
    GoRoute(path: '/emergency_trigger',   builder: (_, __) => const EmergencyTriggerScreen()),
    GoRoute(path: '/emergency_dispatching', builder: (_, __) => const EmergencyDispatchingScreen()),
    GoRoute(path: '/emergency_result',    builder: (_, __) => const EmergencyResultScreen()),

    // ── Live Queue ──────────────────────────────────────────────────────────
    GoRoute(path: '/live_tracker',        builder: (_, __) => const LiveQueueTrackerScreen()),
  ],
);
