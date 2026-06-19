import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(Icons.calendar_month, 'Appointment Reminder', 'Your consultation with Dr. Ayesha is tomorrow at 10:30 AM.', '2 hours ago', true),
          _buildNotificationCard(Icons.emergency, 'Queue Update', 'You are now 3rd in the emergency queue. Estimated wait time is 15 minutes.', '4 hours ago', false, color: Colors.red),
          _buildNotificationCard(Icons.check_circle, 'Registration Complete', 'Welcome to MediQueue! Your account has been verified.', '1 day ago', false, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(IconData icon, String title, String message, String time, bool isUnread, {Color color = const Color(0xFF1D4ED8)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF1F5F9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 16)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Color(0xFF475569))),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          if (isUnread)
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle)),
        ],
      ),
    );
  }
}
