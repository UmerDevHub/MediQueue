import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';

// Custom painter for premium administrative occupancy graph
class HospitalOccupancyPainter extends CustomPainter {
  final List<double> queueData;
  final double animationVal;

  HospitalOccupancyPainter({required this.queueData, required this.animationVal});

  @override
  void paint(Canvas canvas, Size size) {
    if (queueData.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final fillPath = Path();

    final double stepX = size.width / (queueData.length - 1);
    final double maxY = 15.0; // Max queue value scale
    final double graphHeight = size.height - 20;

    double getX(int index) => index * stepX;
    double getY(double value) => size.height - 10 - ((value / maxY) * graphHeight * animationVal);

    path.moveTo(getX(0), getY(queueData[0]));
    fillPath.moveTo(getX(0), size.height);
    fillPath.lineTo(getX(0), getY(queueData[0]));

    for (int i = 1; i < queueData.length; i++) {
      final cx = (getX(i - 1) + getX(i)) / 2;
      final cy = (getY(queueData[i - 1]) + getY(queueData[i])) / 2;
      path.quadraticBezierTo(cx, cy, getX(i), getY(queueData[i]));
      fillPath.quadraticBezierTo(cx, cy, getX(i), getY(queueData[i]));
    }

    fillPath.lineTo(getX(queueData.length - 1), size.height);
    fillPath.close();

    // Draw gradients inside graph
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withValues(alpha: 0.25),
        AppColors.primary.withValues(alpha: 0.00),
      ],
    );

    canvas.drawPath(fillPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(path, linePaint);

    // Draw dots at key nodes
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final dotOuter = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < queueData.length; i++) {
      final p = Offset(getX(i), getY(queueData[i]));
      canvas.drawCircle(p, 5.0, dotPaint);
      canvas.drawCircle(p, 5.0, dotOuter);
    }
  }

  @override
  bool shouldRepaint(covariant HospitalOccupancyPainter oldDelegate) {
    return oldDelegate.animationVal != animationVal || oldDelegate.queueData != queueData;
  }
}

class HospitalAdminDashboardScreen extends ConsumerStatefulWidget {
  const HospitalAdminDashboardScreen({super.key});

  @override
  ConsumerState<HospitalAdminDashboardScreen> createState() => _HospitalAdminDashboardScreenState();
}

class _HospitalAdminDashboardScreenState extends ConsumerState<HospitalAdminDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _graphController;
  
  // Real-time counter simulation
  final int _activeDoctors = 8;
  final int _activeQueues = 12;
  final int _pendingEmergencies = 1;
  final int _avgWaitTimeMinutes = 14;

  final List<double> _occupancyData = [4.0, 7.0, 5.0, 9.0, 12.0, 8.0, 14.0, 10.0];
  final List<String> _graphHours = ['9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM'];

  @override
  void initState() {
    super.initState();
    _graphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _graphController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      context.go('/role_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header panel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mayo Hospital Console',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome, Admin',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  
                  // Logout Button
                  IconButton(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.danger.withValues(alpha: 0.08),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(),

              const SizedBox(height: 24),

              // Emergency Banner
              if (_pendingEmergencies > 0)
                GestureDetector(
                  onTap: () => context.go('/emergency_alert'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28)
                            .animate(onPlay: (controller) => controller.repeat(reverse: true))
                            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 600.ms),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACTIVE EMERGENCY SOS DISPATCH',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Ambulance dispatch pending approval.',
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.2, curve: Curves.easeOutBack).fadeIn(),

              const SizedBox(height: 24),

              // Realtime statistics grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.45,
                children: [
                  _buildStatCard(
                    title: 'Active Patients',
                    value: '$_activeQueues',
                    color: AppColors.primary,
                    icon: Icons.people_alt_rounded,
                  ),
                  _buildStatCard(
                    title: 'Doctors On Duty',
                    value: '$_activeDoctors',
                    color: AppColors.success,
                    icon: Icons.medical_services_rounded,
                  ),
                  _buildStatCard(
                    title: 'Avg Wait Time',
                    value: '$_avgWaitTimeMinutes Min',
                    color: AppColors.warning,
                    icon: Icons.timer_rounded,
                  ),
                  _buildStatCard(
                    title: 'Emergencies',
                    value: '$_pendingEmergencies',
                    color: AppColors.danger,
                    icon: Icons.emergency_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // occupancy chart card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QUEUE LOAD ANALYTICS',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Patient Volume (Today)',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Peak: 14',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Custom paint canvas
                    AnimatedBuilder(
                      animation: _graphController,
                      builder: (context, child) {
                        return SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: HospitalOccupancyPainter(
                              queueData: _occupancyData,
                              animationVal: _graphController.value,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    // X-Axis labels
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _graphHours.map((h) => Text(
                        h,
                        style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      )).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 24),

              // Action shortcuts
              Text(
                'QUICK ACCESS UTILITIES',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),

              _buildActionCard(
                title: 'Live Queue Manager',
                subtitle: 'Monitor bookings, cancel slot queues, serve next patients.',
                icon: Icons.format_list_numbered_rounded,
                color: AppColors.primary,
                route: '/live_queue',
              ),
              
              const SizedBox(height: 12),

              _buildActionCard(
                title: 'Doctors On Duty',
                subtitle: 'Toggle active check-ins, change consulting rooms, edit shifts.',
                icon: Icons.account_circle_rounded,
                color: AppColors.success,
                route: '/doctors_on_duty',
              ),

              const SizedBox(height: 12),

              _buildActionCard(
                title: 'Emergency SOS Center',
                subtitle: 'Manage triage dispatch logs, monitor ambulance channels.',
                icon: Icons.local_hospital_rounded,
                color: AppColors.danger,
                route: '/emergency_alert',
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, color: color.withValues(alpha: 0.7), size: 18),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms);
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.border, size: 14),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}
