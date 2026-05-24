import 'package:flutter/foundation.dart';

class AppConfig {
  static const String supabaseUrl = 'https://cpgqitgdtkjynlwogtfb.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_QKE-li-nnzj11AqwVWEUPw_PGxXMNc9';

  // DYNAMIC URL: Platform ke mutabiq auto-switch hoga (No more hardcoding bugs)
  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000'; // Chrome Web ke liye
    } else {
      return 'http://10.0.2.2:8000'; // Android Emulator ke liye
    }
  }
}
