import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  bool _isOnDuty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Dr. Portal',
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
            // ON DUTY TOGGLE BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isOnDuty
                    ? const Color(0xFF16A34A).withOpacity(0.1)
                    : const Color(0xFF64748B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _isOnDuty
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF64748B)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work,
                          color: _isOnDuty
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF64748B)),
                      const SizedBox(width: 12),
                      Text(_isOnDuty ? 'You are ON DUTY' : 'You are OFF DUTY',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: _isOnDuty
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF64748B))),
                    ],
                  ),
                  Switch(
                    value: _isOnDuty,
                    activeThumbColor: const Color(0xFF16A34A),
                    onChanged: (val) => setState(() => _isOnDuty = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // NEXT APPOINTMENT CARD
            Text('Next Appointment',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text('UA',
                              style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Usman Ali',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text('Routine Checkup',
                                style:
                                    GoogleFonts.inter(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Text('Today, 2:30 PM - 3:00 PM',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2563EB)),
                      onPressed: () {},
                      child: const Text('View User Details'),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Today\'s Schedule',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const SizedBox(height: 12),

            // SCHEDULE LIST
            _buildScheduleItem(
                '03:00 PM', 'Ayesha Tariq', 'Pending', const Color(0xFFD97706)),
            _buildScheduleItem(
                '04:00 PM', 'Ahmed Khan', 'Pending', const Color(0xFFD97706)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
      String time, String userName, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Text(time,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(width: 16),
          Container(width: 2, height: 40, color: const Color(0xFFE2E8F0)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(userName,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4)),
            child: Text(status,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor)),
          )
        ],
      ),
    );
  }
}
