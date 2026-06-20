import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import 'providers/emergency_provider.dart';

class EmergencyResultScreen extends ConsumerWidget {
  const EmergencyResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyState = ref.watch(emergencyProvider);
    final result = emergencyState.dispatchResult;

    // Fallback static values in case the result is null (e.g., debug direct navigation)
    final assignedHosp = result?['assigned_hospital'] as Map<String, dynamic>? ?? {
      'hospital_name': 'Mayo Triage Care Center',
      'distance_km': 1.8,
      'queue_size': 4,
      'eta_minutes': 12.0,
      'load_score': 3.2,
    };

    final fallbackHospitals = (result?['fallback_hospitals'] as List<dynamic>?)
        ?.map((item) => item as Map<String, dynamic>)
        .toList() ?? [
      {
        'hospital_name': 'General Triage Hospital',
        'distance_km': 3.5,
        'queue_size': 8,
        'eta_minutes': 24.0,
        'load_score': 7.1,
      },
      {
        'hospital_name': 'Jinnah Medical Center',
        'distance_km': 5.2,
        'queue_size': 2,
        'eta_minutes': 18.0,
        'load_score': 4.5,
      }
    ];

    final tokenNumber = (result?['queue_entry_id'] as String?)?.split('-').first.toUpperCase().substring(0, 4) ?? 'E-401';
    final hospitalName = assignedHosp['hospital_name'] as String? ?? 'Mayo Triage Care';
    final distance = (assignedHosp['distance_km'] as num? ?? 1.8).toStringAsFixed(1);
    final queueSize = assignedHosp['queue_size'] as int? ?? 4;
    final eta = (assignedHosp['eta_minutes'] as num? ?? 12.0).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Success Animation & Confirmation Banner
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 58,
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.bounceOut),
                    const SizedBox(height: 16),
                    Text(
                      'ROUTE SECURED',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.success,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Priority Triage Enqueued Successfully',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. Primary Hospital Card (Clinical Digital Ticket Style)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Card Top: Hospital Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.04),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ASSIGNED DESTINATION',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hospitalName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Card Middle: Stats Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTicketStat('ETA', '$eta min', Icons.timer_outlined),
                          Container(width: 1, height: 40, color: AppColors.border),
                          _buildTicketStat('Distance', '$distance km', Icons.directions_outlined),
                          Container(width: 1, height: 40, color: AppColors.border),
                          _buildTicketStat('Triage Ticket', tokenNumber, Icons.confirmation_num_outlined),
                        ],
                      ),
                    ),

                    // Card Divider Dot Lines
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: List.generate(
                          30,
                          (index) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 1,
                              color: index % 2 == 0 ? Colors.transparent : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Card Bottom: Queue position alert info
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_alt_rounded, color: AppColors.textSecondary, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Active queue: $queueSize patients ahead',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 28),

              // 3. Fallback alternative routes title
              Text(
                'Alternative Hospitals',
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // 4. Fallback alternative routes List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fallbackHospitals.length,
                itemBuilder: (context, index) {
                  final hosp = fallbackHospitals[index];
                  final fName = hosp['hospital_name'] as String? ?? 'General Hospital';
                  final fDist = (hosp['distance_km'] as num? ?? 3.5).toStringAsFixed(1);
                  final fEta = (hosp['eta_minutes'] as num? ?? 20.0).toStringAsFixed(0);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fName,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$fDist km away',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$fEta min',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),

              // 5. Actions CTA Block
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Mock opening google maps directions
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Launching Google Maps Navigation...'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.navigation_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Navigate in Maps',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              // Mock call hospital
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling Hospital Emergency Desk (+92 42 111-222-333)...'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border, width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone_rounded, size: 16, color: AppColors.textPrimary),
                                const SizedBox(width: 6),
                                Text(
                                  'Call Desk',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Reset state and redirect to active tracker
                              ref.read(emergencyProvider.notifier).reset();
                              context.go('/live_tracker');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.track_changes_rounded, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Track Queue',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
