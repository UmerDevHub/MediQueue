import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user name safely
    final userName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['full_name'] ??
            'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Good morning, ${userName.split(" ")[0]}',
            style: GoogleFonts.inter(
                color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EMERGENCY TRIGGER CARD
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/emergency_trigger'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(220, 38, 38, 0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emergency, color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    Text('Get Emergency Help',
                        style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Tap to dispatch to nearest hospital',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // APPOINTMENTS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(37, 99, 235, 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.calendar_month,
                      color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  Text('Book Appointment',
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Find doctors and reserve slots',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Recent Activity',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const SizedBox(height: 16),

            // Static mockup for now
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.local_hospital,
                        color: Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emergency Dispatch',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A))),
                        Text('City Hospital • Last week',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text('Completed',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF16A34A))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
