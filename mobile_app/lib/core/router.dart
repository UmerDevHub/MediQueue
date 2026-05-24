import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/user_login/login_screen.dart';
import '../features/auth/user_signup/signup_screen.dart';
import '../features/user/home/user_home.dart';
import '../features/user/emergency_trigger/emergency_trigger.dart';
import '../features/user/live_queue_tracker/live_tracker.dart';
import '../features/doctor/home/doctor_home.dart';
import '../features/hospital_admin/dashboard/admin_home.dart';

Future<bool> _isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return (prefs.getString('token') ?? '').isNotEmpty;
}

final appRouter = GoRouter(
  initialLocation: '/signup',
  redirect: (context, state) async {
    final loggedIn = await _isLoggedIn();
    final isLoggingInOrSigningUp = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
    
    if (!loggedIn && !isLoggingInOrSigningUp) {
      return '/login';
    }
    if (loggedIn && isLoggingInOrSigningUp) {
      return '/user_home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
    GoRoute(path: '/user_home', builder: (_, __) => const UserHome()),
    GoRoute(path: '/emergency_trigger', builder: (_, __) => const EmergencyTriggerScreen()),
    GoRoute(path: '/live_tracker', builder: (_, __) => const LiveTrackerScreen()),
    GoRoute(path: '/doctor_home', builder: (_, __) => const DoctorHome()),
    GoRoute(path: '/admin_home', builder: (_, __) => const AdminHome()),
  ],
);
