import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/user_home_provider.dart';
import '../providers/appointments_provider.dart';

class DoctorDetailScreen extends ConsumerStatefulWidget {
  const DoctorDetailScreen({super.key});

  @override
  ConsumerState<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends ConsumerState<DoctorDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _selectedSlot;
  bool _isBooking = false;

  // Mock Reviews data
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'name': 'Sarah Ahmed',
      'rating': 5.0,
      'date': '2 days ago',
      'comment': 'Dr. Aisha was extremely professional and explained the entire diagnosis clearly. Highly recommended!'
    },
    {
      'name': 'Muhammad Ali',
      'rating': 4.0,
      'date': '1 week ago',
      'comment': 'Very polite doctor. The waiting time was about 15 minutes, but the consultation was thorough.'
    },
    {
      'name': 'Zainab Bibi',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment': 'Outstanding experience. She is very patient and gentle with pediatric cases.'
    }
  ];

  // Mock clinic busy hours load (hourly percentage)
  final List<double> _hourlyTraffic = [15, 30, 65, 80, 95, 75, 40, 25, 10];
  final List<String> _trafficLabels = ['9AM', '10AM', '11AM', '12PM', '1PM', '2PM', '3PM', '4PM', '5PM'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDates() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  String _getTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  void _handleConfirmBooking(Map<String, dynamic> doctor) async {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an available time slot first.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    final authState = ref.read(authProvider);
    final apiService = ref.read(userApiServiceProvider);
    
    final userId = authState.user?.id ?? '';
    final doctorId = doctor['id'] as String? ?? doctor['doctor_id'] as String? ?? '';
    final slotId = _selectedSlot!['id'] as String? ?? '';

    try {
      final bookingResult = await apiService.bookAppointment(
        userId: userId,
        doctorId: doctorId,
        slotId: slotId,
      );

      final newAppt = {
        'id': bookingResult['id'] ?? bookingResult['appointment_id'] ?? '',
        'status': 'booked',
        'doctor': doctor,
        'slot': _selectedSlot,
      };

      // Add to local appointments database list
      await ref.read(appointmentsProvider.notifier).addAppointment(newAppt);

      // Save confirmed details in provider
      ref.read(confirmedAppointmentProvider.notifier).state = {
        ...bookingResult,
        'doctor': doctor,
        'slot': _selectedSlot,
      };

      if (mounted) {
        context.go('/booking_confirmation');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 28),
                const SizedBox(width: 10),
                Text('Booking Failed', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18)),
              ],
            ),
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ref.watch(selectedDoctorProvider);

    if (doctor == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'No doctor selected',
            style: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final name = doctor['name'] as String? ?? 'Doctor';
    final specialty = doctor['specialization'] as String? ?? 'Specialist';
    final hospital = doctor['hospital_name'] as String? ?? 'General Hospital';
    final rating = (doctor['rating'] as num? ?? 4.8).toStringAsFixed(1);
    final experience = (doctor['experience_years'] as int? ?? 5).toString();
    final bio = doctor['bio'] as String? ?? 'Highly qualified healthcare professional dedicated to patient care and clinical excellence. Specialized in diagnostics and comprehensive treatment layouts.';

    final slotsAsync = ref.watch(doctorSlotsProvider);
    final dates = _generateDates();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Navigation Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/appointments_home'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.border, width: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Doctor Details',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium Doctor Header Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'doc-avatar-${doctor['id']}',
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(
                                  name.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '$specialty • $hospital',
                                    style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        rating,
                                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(width: 14),
                                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.textSecondary, shape: BoxShape.circle)),
                                      const SizedBox(width: 14),
                                      Text(
                                        '$experience Yrs Exp',
                                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 350.ms),

                    // Navigation Tabs: Info, Busy Times, Reviews
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          tabs: const [
                            Tab(text: 'Biography'),
                            Tab(text: 'Queue Load'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                      ),
                    ),

                    // Tab Views Content
                    Container(
                      height: 180,
                      margin: const EdgeInsets.only(top: 16),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Tab 1: Biography
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Specialized Biography',
                                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bio,
                                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Tab 2: Queue Traffic Load
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Clinic Queue Load Analytics',
                                      style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                    ),
                                    Text(
                                      'Peak Hours: 12PM-2PM',
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(_hourlyTraffic.length, (idx) {
                                      final load = _hourlyTraffic[idx];
                                      final label = _trafficLabels[idx];
                                      final isPeak = load > 70;
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 14,
                                            height: (load / 100) * 80,
                                            decoration: BoxDecoration(
                                              color: isPeak ? AppColors.danger : AppColors.primary,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tab 3: Reviews
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            itemCount: _mockReviews.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, idx) {
                              final rev = _mockReviews[idx];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border, width: 0.8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(rev['name'] as String, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                        Text(rev['date'] as String, style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(5, (sIdx) {
                                        return Icon(
                                          Icons.star_rounded,
                                          size: 13,
                                          color: sIdx < (rev['rating'] as double).floor() ? Colors.amber : Colors.grey[300],
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(rev['comment'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: AppColors.border, height: 32),

                    // Calendar Selection Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Select Appointment Date', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),
                    
                    // Horizontal scrollable dates row
                    SizedBox(
                      height: 76,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final date = dates[index];
                          final isSelected = DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(_selectedDate);
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                                _selectedSlot = null; // Reset slot
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 12),
                              width: 62,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: 0.8,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('E').format(date).toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormat('dd').format(date),
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 24),

                    // Available slots grid matching database schema
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Available Time Slots', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: slotsAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                        error: (err, stack) => Text(
                          'Failed to load slots: $err',
                          style: GoogleFonts.inter(color: AppColors.danger, fontSize: 13.5),
                        ),
                        data: (allSlots) {
                          final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
                          final dailySlots = allSlots.where((slot) {
                            final startTimeStr = slot['start_time'] as String? ?? '';
                            if (startTimeStr.isEmpty) return false;
                            final slotDate = DateTime.tryParse(startTimeStr);
                            if (slotDate == null) return false;
                            final isUnbooked = !(slot['is_booked'] as bool? ?? false);
                            return DateFormat('yyyy-MM-dd').format(slotDate) == dateString && isUnbooked;
                          }).toList();

                          if (dailySlots.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                child: Text(
                                  'No available slots for this date.',
                                  style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13.5),
                                ),
                              ),
                            );
                          }

                          final morningSlots = dailySlots.where((s) => _getTimeOfDay(DateTime.parse(s['start_time'] as String)) == 'Morning').toList();
                          final afternoonSlots = dailySlots.where((s) => _getTimeOfDay(DateTime.parse(s['start_time'] as String)) == 'Afternoon').toList();
                          final eveningSlots = dailySlots.where((s) => _getTimeOfDay(DateTime.parse(s['start_time'] as String)) == 'Evening').toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (morningSlots.isNotEmpty) ...[
                                _buildTimePeriodHeader('Morning Slots', Icons.wb_twilight),
                                _buildSlotsGrid(morningSlots),
                              ],
                              if (afternoonSlots.isNotEmpty) ...[
                                _buildTimePeriodHeader('Afternoon Slots', Icons.wb_sunny_rounded),
                                _buildSlotsGrid(afternoonSlots),
                              ],
                              if (eveningSlots.isNotEmpty) ...[
                                _buildTimePeriodHeader('Evening Slots', Icons.nights_stay_rounded),
                                _buildSlotsGrid(eveningSlots),
                              ],
                            ],
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Confirm Booking Action Panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isBooking ? null : () => _handleConfirmBooking(doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isBooking
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Confirm Appointment',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotsGrid(List<Map<String, dynamic>> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final time = DateFormat('hh:mm a').format(DateTime.parse(slot['start_time'] as String));
        final isSelected = _selectedSlot != null && _selectedSlot!['id'] == slot['id'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
