import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme.dart';

// Custom painter for pulsing radar circles
class EmergencyRadarPainter extends CustomPainter {
  final double animationVal;

  EmergencyRadarPainter({required this.animationVal});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 1; i <= 3; i++) {
      final radiusProgress = (animationVal + (i / 3.0)) % 1.0;
      final radius = maxRadius * radiusProgress;
      final opacity = 1.0 - radiusProgress;

      final circlePaint = Paint()
        ..color = AppColors.danger.withValues(alpha: opacity * 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, circlePaint);
    }

    // Core pulsing dot
    final corePaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8.0, corePaint);
  }

  @override
  bool shouldRepaint(covariant EmergencyRadarPainter oldDelegate) {
    return oldDelegate.animationVal != animationVal;
  }
}

class IncomingEmergencyAlertScreen extends ConsumerStatefulWidget {
  const IncomingEmergencyAlertScreen({super.key});

  @override
  ConsumerState<IncomingEmergencyAlertScreen> createState() => _IncomingEmergencyAlertScreenState();
}

class _IncomingEmergencyAlertScreenState extends ConsumerState<IncomingEmergencyAlertScreen> with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  late AnimationController _radarController;
  
  Map<String, dynamic>? _activeIncident;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _fetchActiveIncidents();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  Future<void> _fetchActiveIncidents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Query active emergencies assigned to Mayo Hospital
      final response = await _supabase
          .from('incidents')
          .select('*, users(*)')
          .eq('assigned_hospital_id', '38c92a2a-b032-4415-9988-bb735dbd2b1f')
          .neq('status', 'resolved')
          .order('created_at', ascending: false)
          .limit(1);

      final List<dynamic> data = response as List<dynamic>;

      setState(() {
        if (data.isNotEmpty) {
          _activeIncident = data[0] as Map<String, dynamic>;
        } else {
          _activeIncident = null;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to query emergencies: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _resolveIncident(String incidentId, String finalStatus) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Update incident status in Supabase
      await _supabase
          .from('incidents')
          .update({'status': finalStatus})
          .eq('id', incidentId);

      setState(() {
        _isProcessing = false;
      });

      await _fetchActiveIncidents();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(finalStatus == 'accepted' 
                ? 'SOS Request Accepted. Dispatch teams notified.' 
                : 'SOS request rerouted to nearest facility.'),
            backgroundColor: finalStatus == 'accepted' ? AppColors.success : AppColors.warning,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action failed: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Emergency SOS Console',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.go('/admin_home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
        ),
        actions: [
          IconButton(
            onPressed: _fetchActiveIncidents,
            icon: const Icon(Icons.refresh_rounded, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              )
            : _activeIncident == null
                ? _buildRadarScanningView()
                : _buildAlertDetailsView(_activeIncident!),
      ),
    );
  }

  Widget _buildRadarScanningView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: AnimatedBuilder(
              animation: _radarController,
              builder: (context, child) {
                return CustomPaint(
                  painter: EmergencyRadarPainter(animationVal: _radarController.value),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'SCANNING FOR SOS BEACONS',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Monitoring live GPS telemetry and incident requests...',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertDetailsView(Map<String, dynamic> incident) {
    final patient = incident['users'];
    final String symptoms = incident['symptoms'] ?? 'No symptom description provided.';
    final double severity = (incident['severity_score'] as num?)?.toDouble() ?? 5.0;
    final bool ambRequired = incident['ambulance_required'] ?? false;
    final String status = incident['status'] ?? 'pending';

    Color severityColor = AppColors.warning;
    if (severity >= 7.5) severityColor = AppColors.danger;
    if (severity < 5.0) severityColor = AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flashing danger indicator header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_rounded, color: AppColors.danger, size: 28)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 500.ms),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CRITICAL INCOMING SIGNAL',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.danger,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Triage emergency category received.',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().shake(),

          const SizedBox(height: 24),

          // Severity & Ambulance telemetry cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SEVERITY SCORE',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$severity / 10',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: severityColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AMBULANCE',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ambRequired ? 'REQUIRED' : 'NOT NEEDED',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: ambRequired ? AppColors.danger : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Patient core details card
          Text(
            'PATIENT TELEMETRY',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient != null ? (patient['name'] ?? 'Unknown User') : 'SOS Anonymous',
                            style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            patient != null ? (patient['phone'] ?? 'No Phone') : 'Telemetry Link Only',
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 24, color: AppColors.border),
                
                Text(
                  'REPORTED SYMPTOMS:',
                  style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  symptoms,
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Geolocation visual
          Text(
            'GPS COORDINATES',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.danger, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location: Lahore, Pakistan',
                        style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lat: ${incident['lat'] ?? '31.5725'} • Lng: ${incident['lng'] ?? '74.3106'}',
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Action dispatch buttons
          if (status == 'pending') ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _resolveIncident(incident['id'], 'accepted'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : Text(
                        'Accept SOS & Dispatch Responder',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _isProcessing ? null : () => _resolveIncident(incident['id'], 'rerouted'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger, width: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Decline Request & Reroute Responder',
                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: status == 'accepted' ? AppColors.success.withValues(alpha: 0.08) : AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  status == 'accepted' 
                      ? '✓ SOS DISPATCH ACCEPTED' 
                      : '⚠ INCIDENT REROUTED',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: status == 'accepted' ? AppColors.success : AppColors.warning,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
