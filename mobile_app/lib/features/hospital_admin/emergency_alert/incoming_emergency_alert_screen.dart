import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IncomingEmergencyAlertScreen extends StatelessWidget {
  const IncomingEmergencyAlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.go('/admin_home'),
        ),
        title: const Text('Emergency Alerts',
            style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
              child: const Icon(Icons.warning_amber, color: Color(0xFFDC2626), size: 64),
            ),
            const SizedBox(height: 24),
            const Text('Incoming Emergency Alerts',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('Real-time triage stream active.',
                style: TextStyle(color: Color(0xFF475569))),
          ],
        ),
      ),
    );
  }
}
