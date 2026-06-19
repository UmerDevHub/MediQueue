import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: Color(0xFF1D4ED8), size: 50),
              ),
              const SizedBox(height: 24),
              const Text('Appointment Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              const Text('Your consultation has been successfully scheduled.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569))),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Dr. Ayesha Khan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              Text('Senior Cardiologist', style: TextStyle(color: Color(0xFF475569))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(16)),
                          child: const Text('Booked', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.calendar_today, 'Oct 25, 2023 • 10:30 AM'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on_outlined, 'City Hospital, Main Wing'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.fingerprint, 'ID: MQ-9821'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('WAIT TIME', style: TextStyle(fontSize: 10, color: Color(0xFF475569))),
                                SizedBox(height: 4),
                                Text('~15 Mins', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('ROOM NO.', style: TextStyle(fontSize: 10, color: Color(0xFF475569))),
                                SizedBox(height: 4),
                                Text('402-B', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/user_home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.home_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text('BACK TO HOME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1D4ED8)),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_month, color: Color(0xFF1D4ED8)),
                    SizedBox(width: 8),
                    Text('ADD TO CALENDAR', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('Please arrive 10 minutes before your scheduled slot.', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
              const Text('Cancellation Policy', style: TextStyle(fontSize: 12, color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF475569)),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Color(0xFF0F172A))),
      ],
    );
  }
}
