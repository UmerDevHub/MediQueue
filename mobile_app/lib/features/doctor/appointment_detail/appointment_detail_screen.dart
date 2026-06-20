import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  ConsumerState<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends ConsumerState<AppointmentDetailScreen> {
  final _notesController = TextEditingController();
  final _prescriptionController = TextEditingController();
  
  bool _isSaving = false;
  String _activeStatus = 'Scheduled'; // Scheduled, Serving, Completed, Cancelled

  @override
  void initState() {
    super.initState();
    // Pre-populate mock note entries
    _notesController.text = 'Patient reports recurring symptoms post-meal. Recommended low-fat diet and cardiac stress monitoring.';
    _prescriptionController.text = 'Tab. Gaviscon 10ml - thrice daily (Before meals)\nTab. Panadol 500mg - SOS (For body ache)';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  void _saveClinicalDetails() async {
    setState(() {
      _isSaving = true;
    });

    // Simulate backend updates
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isSaving = false;
        _activeStatus = 'Completed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription and consultation notes saved successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/doctor_home');
    }
  }

  void _cancelAppointment() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Cancel Appointment',
            style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.danger),
          ),
          content: Text(
            'Are you sure you want to cancel this slot? An automated notification will be sent to the patient.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep Slot', style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _activeStatus = 'Cancelled';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment has been marked as Cancelled.'), backgroundColor: AppColors.danger),
                );
                context.go('/doctor_home');
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: Text('Cancel Appointment', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => context.go('/doctor_home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
        ),
        title: Text(
          'Appointment Case Detail',
          style: GoogleFonts.inter(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Patient Info Card
              _buildPatientHeaderCard(),

              const SizedBox(height: 24),

              // 2. Pre-consultation symptoms recorded
              Text(
                'Triage Intake Symptoms',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildIntakeChip('Chest Tightness', Colors.red),
                        _buildIntakeChip('Shortness of breath', Colors.orange),
                        _buildIntakeChip('Acid Reflux', Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Symptom description entered by patient at enqueuing stage. Triage receptionist confirms no prior history of chronic asthma.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Clinical Diary (Prescription and Diagnostic Notes)
              Text(
                'Clinical Consultation Notes',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIAGNOSTIC ADVICE',
                      style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter observation, diagnosis advice here...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PRESCRIPTION / MEDICATION',
                      style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _prescriptionController,
                      maxLines: 4,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter medicines, dosage, frequency here...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. Lab Reports attachment panel
              Text(
                'Laboratory Report Attachments',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ECG_Report_Ahmad_Ali.pdf',
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Uploaded via patient app • 1.2 MB',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading attachment to local disk...')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 5. Console Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveClinicalDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : Text(
                              'Save & Close Case',
                              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _cancelAppointment,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.danger),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                    child: Text(
                      'Cancel Slot',
                      style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CASE ID: ${widget.appointmentId.isNotEmpty ? widget.appointmentId.substring(0, math.min(8, widget.appointmentId.length)) : 'APPT-9811'}',
                style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _activeStatus == 'Completed'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : (_activeStatus == 'Cancelled' ? AppColors.danger.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _activeStatus,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: _activeStatus == 'Completed'
                        ? AppColors.success
                        : (_activeStatus == 'Cancelled' ? AppColors.danger : AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  'A',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmad Ali',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '34 yrs • Male • Health Card: HC-982188',
                      style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
