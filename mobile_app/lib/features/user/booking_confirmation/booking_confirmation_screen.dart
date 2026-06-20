import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../providers/booking_provider.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmedData = ref.watch(confirmedAppointmentProvider);

    if (confirmedData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No confirmation data found', style: GoogleFonts.inter(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/user_home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final doctor = confirmedData['doctor'] as Map<String, dynamic>? ?? {};
    final slot = confirmedData['slot'] as Map<String, dynamic>? ?? {};
    
    final docName = doctor['name'] as String? ?? 'Doctor';
    final docSpecialty = doctor['specialization'] as String? ?? 'Specialist';
    final hospital = doctor['hospital_name'] as String? ?? 'General Hospital';

    final startTimeStr = slot['start_time'] as String? ?? '';
    final slotTime = startTimeStr.isNotEmpty
        ? DateFormat('hh:mm a').format(DateTime.parse(startTimeStr))
        : 'Scheduled Time';
    final slotDate = startTimeStr.isNotEmpty
        ? DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(startTimeStr))
        : 'Scheduled Date';

    // Mock token number from UUID snippet or DB index
    final appointmentId = confirmedData['appointment_id'] as String? ?? '';
    final tokenNumber = appointmentId.isNotEmpty ? appointmentId.substring(0, 4).toUpperCase() : 'MQ09';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              
              // Animated Check Circle Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).then().shake(duration: 300.ms),

              const SizedBox(height: 20),

              // Title
              Text(
                'Booking Confirmed!',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 6),
              
              Text(
                'Your doctor slot has been reserved successfully.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 250.ms),

              const SizedBox(height: 28),

              // 2. High-Fidelity Ticket Widget Layout
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  children: [
                    // Ticket Top
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  docSpecialty.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ACTIVE',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                                child: Text(
                                  docName.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docName,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      hospital,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Ticket Scallop Divider
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(
                                    (constraints.constrainWidth() / 10).floor(),
                                    (index) => SizedBox(
                                      width: 5,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.grey[300]),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Ticket Bottom
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildTicketInfoRow('Date', slotDate, Icons.calendar_month_rounded),
                          const SizedBox(height: 12),
                          _buildTicketInfoRow('Time', slotTime, Icons.access_time_filled),
                          const SizedBox(height: 12),
                          _buildTicketInfoRow('Queue Token', '#$tokenNumber', Icons.confirmation_number_rounded),
                          const SizedBox(height: 24),
                          
                          // Mock Barcode
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(32, (index) {
                                  final isSpace = index % 5 == 0;
                                  final width = index % 3 == 0 ? 3.5 : 1.5;
                                  return Container(
                                    width: isSpace ? 2 : width,
                                    height: 38,
                                    color: isSpace ? Colors.transparent : AppColors.textPrimary,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.2),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                appointmentId.toUpperCase(),
                                style: GoogleFonts.sourceCodePro(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.08, end: 0),

              const SizedBox(height: 36),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Tracker page
                    context.go('/live_tracker');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Track Live Queue',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.track_changes_rounded, size: 18),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context.go('/user_home'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Return to Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
