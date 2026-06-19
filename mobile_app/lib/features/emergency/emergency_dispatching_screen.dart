import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyDispatchingScreen extends StatefulWidget {
  const EmergencyDispatchingScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyDispatchingScreen> createState() => _EmergencyDispatchingScreenState();
}

class _EmergencyDispatchingScreenState extends State<EmergencyDispatchingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(_pulseController);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.go('/emergency_result');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text('MediQueue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
              const SizedBox(height: 8),
              const Text('Emergency Dispatch Protocol',
                  style: TextStyle(fontSize: 16, color: Color(0xFF334155))),
              const SizedBox(height: 48),
              ScaleTransition(
                scale: _pulseAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFCA5A5), width: 2),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB91C1C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emergency, color: Colors.white, size: 48),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.sensors, color: Color(0xFFB91C1C), size: 16),
                            SizedBox(width: 4),
                            Text('SCANNING',
                                style: TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const Text('Finding nearest available hospital...',
                  style: TextStyle(fontSize: 16, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              const Text('REAL-TIME GRID COORDINATION\nACTIVE',
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 1.5, color: Color(0xFF475569))),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      _buildStep(
                          icon: Icons.check,
                          iconColor: Colors.blue,
                          bgColor: const Color(0xFFDBEAFE),
                          title: 'Location detected',
                          subtitle: 'GPS coordinates acquired'),
                      const SizedBox(height: 16),
                      _buildStep(
                          icon: Icons.arrow_forward,
                          iconColor: Colors.white,
                          bgColor: const Color(0xFF1D4ED8),
                          title: 'Scanning hospitals',
                          isDividerActive: true),
                      const SizedBox(height: 16),
                      _buildStep(
                          icon: Icons.more_horiz,
                          iconColor: Colors.grey,
                          bgColor: Colors.white,
                          title: 'Checking queue loads',
                          subtitle: 'ML scoring active...'),
                      const SizedBox(height: 16),
                      _buildStep(
                          icon: Icons.assignment_ind_outlined,
                          iconColor: Colors.grey,
                          bgColor: Colors.white,
                          title: 'Assigning hospital'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, color: Colors.white),
                    SizedBox(width: 8),
                    Text('CANCEL & CALL 1122',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/user_home'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text('BACK TO DASHBOARD',
                    style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    String? subtitle,
    bool isDividerActive = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                  color: bgColor == Colors.white ? Colors.grey.shade300 : Colors.transparent)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16, color: iconColor == Colors.white ? Colors.black : Colors.grey)),
              if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (isDividerActive)
                Container(margin: const EdgeInsets.only(top: 8), height: 2, color: Colors.blue),
            ],
          ),
        ),
      ],
    );
  }
}
