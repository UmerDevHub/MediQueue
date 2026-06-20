import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../user/providers/appointments_provider.dart';
import '../user/providers/user_home_provider.dart';

class LiveQueueTrackerScreen extends ConsumerStatefulWidget {
  const LiveQueueTrackerScreen({super.key});

  @override
  ConsumerState<LiveQueueTrackerScreen> createState() => _LiveQueueTrackerScreenState();
}

class _LiveQueueTrackerScreenState extends ConsumerState<LiveQueueTrackerScreen> {
  bool _isRefreshing = false;
  int _mockServingNumber = 11;
  int _mockUserToken = 14;
  String _liveWaitTime = '15';
  String? _trackerError;

  @override
  void initState() {
    super.initState();
    _fetchLiveWaitTime();
  }

  Future<void> _fetchLiveWaitTime() async {
    final appointmentsList = ref.read(appointmentsProvider);
    final active = appointmentsList.where((appt) => appt['status'] == 'booked').toList();
    if (active.isEmpty) return;

    final appt = active.first;
    final doctor = appt['doctor'] as Map<String, dynamic>? ?? {};
    final hospitalId = doctor['hospital_id'] as String? ?? '';

    if (hospitalId.isEmpty || hospitalId.startsWith('mock-')) {
      setState(() {
        _liveWaitTime = '18';
        _trackerError = null;
      });
      return;
    }

    setState(() {
      _isRefreshing = true;
      _trackerError = null;
    });

    try {
      final apiService = ref.read(userApiServiceProvider);
      final waitTimeData = await apiService.getHospitalWaitTime(hospitalId);
      final eta = (waitTimeData['eta_minutes'] as num? ?? 15.0).toStringAsFixed(0);
      
      setState(() {
        _liveWaitTime = eta;
        // Mock serving number relative to token
        _mockServingNumber = (waitTimeData['queue_size'] as int? ?? 12) - 3;
        if (_mockServingNumber <= 0) _mockServingNumber = 1;
        _mockUserToken = _mockServingNumber + 3;
      });
    } catch (e) {
      setState(() {
        _trackerError = e.toString().replaceAll('Exception: ', '');
        _liveWaitTime = '22'; // fallback
      });
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsList = ref.watch(appointmentsProvider);
    final active = appointmentsList.where((appt) => appt['status'] == 'booked').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header panel
            _buildHeaderPanel(active.isNotEmpty),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchLiveWaitTime,
                color: AppColors.primary,
                child: active.isEmpty
                    ? _buildEmptyState()
                    : _buildTrackerContent(active.first),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 2),
    );
  }

  Widget _buildHeaderPanel(bool hasActive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Live Queue Tracker',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (hasActive)
            IconButton(
              onPressed: _isRefreshing ? null : _fetchLiveWaitTime,
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                    )
                  : const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
                child: const Icon(Icons.track_changes_rounded, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(
                'No Active Queue',
                style: GoogleFonts.inter(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'You do not have any active appointments scheduled for today. Book an appointment to track your live queue status.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => context.go('/appointments_home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Find Doctors Now', style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerContent(Map<String, dynamic> appointment) {
    final doctor = appointment['doctor'] as Map<String, dynamic>? ?? {};
    final docName = doctor['name'] as String? ?? 'Doctor';
    final docSpecialty = doctor['specialization'] as String? ?? 'Specialist';
    final hospital = doctor['hospital_name'] as String? ?? 'General Hospital';

    final peopleAhead = _mockUserToken - _mockServingNumber;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Doctor Info Strip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  child: Text(
                    docName.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docName,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$docSpecialty • $hospital',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 20),

          // Wait Time Large Graphic Display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'ESTIMATED WAIT TIME',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _liveWaitTime,
                      style: GoogleFonts.inter(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                      child: Text(
                        'min',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _trackerError != null
                      ? 'Reconnecting... Using offline wait profile.'
                      : 'ML predicted based on queue pace & load statistics.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 20),

          // Token Dashboard Counters
          Row(
            children: [
              Expanded(
                child: _buildCounterCard('YOUR TOKEN', '#$_mockUserToken', AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCounterCard('NOW SERVING', '#$_mockServingNumber', AppColors.success),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Live Progress Steps
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Queue Progress',
                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 18),
                _buildProgressStep('Checked In', 'Validated queue status at reception', true, true),
                _buildProgressStep('Vitals Checked', 'Vitals checked by triage staff', true, true),
                _buildProgressStep(
                  'Standby Waiting',
                  peopleAhead > 0 ? '$peopleAhead patients ahead of you' : 'You are next in line!',
                  true,
                  false,
                  isActive: true,
                ),
                _buildProgressStep('Doctor Consultation', 'Consultation with physician', false, false),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms),

          const SizedBox(height: 20),

          // Directions Reminder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please remain near Clinic Room 3B. Keep this screen open to check real-time queue turns.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildCounterCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String title, String subtitle, bool isCompleted, bool showLine, {bool isActive = false}) {
    Color iconColor = isCompleted ? AppColors.success : Colors.grey[300]!;
    if (isActive) iconColor = AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: isActive ? 2 : 1),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: 12, color: iconColor)
                    : Container(width: 6, height: 6, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle)),
              ),
            ),
            if (showLine)
              Container(
                width: 1.5,
                height: 38,
                color: isCompleted ? AppColors.success : Colors.grey[300]!,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : (isCompleted ? AppColors.textPrimary : AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Shared Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context, int activeIndex) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: activeIndex,
          onTap: (index) {
            if (index == activeIndex) return;
            switch (index) {
              case 0:
                context.go('/user_home');
                break;
              case 1:
                context.go('/appointments_home');
                break;
              case 2:
                context.go('/live_tracker');
                break;
              case 3:
                context.go('/user_profile');
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes_rounded), label: 'Tracker'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
