import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  String _selectedDate = '19';
  String _selectedSlot = '10:00 AM';
  bool _isBooking = false;

  Future<void> _confirmBooking() async {
    setState(() => _isBooking = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('appointments').insert({
          'user_id': user.id,
          // Hardcoding doctor ID for demo purposes based on UI
          'doctor_id': 'd7b1a1c1-1234-4a4a-b5b5-6c6c6c6c6c6c',
          'appointment_time': '2024-03-19T10:00:00Z',
          'status': 'pending',
          'reason': 'General Consultation',
        });
      }
      if (mounted) {
        // Show success and pop
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('MediQueue', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Dr. Ayesha Khan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const Text('General Physician • City Hospital', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
            const SizedBox(height: 8),
            const Text('LICENSE: PMC-92837-GK', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), letterSpacing: 1)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star_half, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(' (124 reviews)', style: TextStyle(color: Color(0xFF64748B))),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('SELECT DATE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                      Text('March 2024', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDateBox('MON', '18'),
                        _buildDateBox('TUE', '19'),
                        _buildDateBox('WED', '20'),
                        _buildDateBox('THU', '21'),
                        _buildDateBox('FRI', '22'),
                        _buildDateBox('SAT', '23'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('AVAILABLE SLOTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: [
                      _buildTimeSlot('09:00 AM'),
                      _buildTimeSlot('09:30 AM', isDisabled: true),
                      _buildTimeSlot('10:00 AM'),
                      _buildTimeSlot('10:30 AM'),
                      _buildTimeSlot('11:00 AM'),
                      _buildTimeSlot('11:30 AM', isDisabled: true),
                      _buildTimeSlot('12:00 PM'),
                      _buildTimeSlot('12:30 PM'),
                      _buildTimeSlot('01:00 PM'),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xFF1D4ED8)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Location', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('OPD Block B, 2nd Floor, City Hospital, Karachi', style: TextStyle(color: Color(0xFF475569))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.payments_outlined, color: Color(0xFF1D4ED8)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Consultation Fee', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('PKR 2,500', style: TextStyle(color: Color(0xFF475569))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // space for bottom fixed button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isBooking ? null : _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isBooking
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Confirm Booking', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle_outline, color: Colors.white),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBox(String day, String date) {
    bool isSelected = _selectedDate == date;
    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D4ED8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(color: isSelected ? Colors.white70 : const Color(0xFF64748B), fontSize: 12)),
            Text(date, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, {bool isDisabled = false}) {
    bool isSelected = _selectedSlot == time && !isDisabled;
    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedSlot = time),
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFE2E8F0) : (isSelected ? const Color(0xFF1D4ED8) : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDisabled ? const Color(0xFFCBD5E1) : (isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF1D4ED8))),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isDisabled ? const Color(0xFF94A3B8) : (isSelected ? Colors.white : const Color(0xFF1D4ED8)),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isDisabled)
              CustomPaint(
                size: Size.infinite,
                painter: StrikeThroughPainter(),
              ),
          ],
        ),
      ),
    );
  }
}

class StrikeThroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
