import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../providers/user_home_provider.dart';
import '../providers/booking_provider.dart';

// ============================================================================
// 1. DISTANCE RADIUS RADAR PAINTER
// ============================================================================

/// Custom painter to draw a premium radar visual showing the search radius (e.g., 2km, 5km, 10km).
class DistanceRadiusPainter extends CustomPainter {
  final double radiusKilometers; // User selected radius in km
  final double maxRadius; // Maximum scale (e.g., 15.0 km)
  final double pulseValue; // Animated breathing value
  final List<Offset> mockDoctorOffsets; // Coordinates of doctors inside radius

  DistanceRadiusPainter({
    required this.radiusKilometers,
    required this.maxRadius,
    required this.pulseValue,
    required this.mockDoctorOffsets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxPhysicalRadius = math.min(size.width, size.height) / 2 - 16;
    
    // Convert selected km radius to physical pixels on canvas
    final activePhysicalRadius = (radiusKilometers / maxRadius) * maxPhysicalRadius;

    // Paint 1: Dark Radar Background Glow
    final bgPaint = Paint()
      ..color = const Color(0xFF0F1E36)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxPhysicalRadius, bgPaint);

    // Paint 2: Concentric Circular Grid Lines (Representing 5km, 10km, etc)
    final gridPaint = Paint()
      ..color = const Color(0xFF1E2D4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    for (double r = 0.25; r <= 1.0; r += 0.25) {
      canvas.drawCircle(center, maxPhysicalRadius * r, gridPaint);
    }

    // Paint 3: Radar Sweep Sweep Shader
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        colors: [
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.primary.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxPhysicalRadius))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(pulseValue * 2 * math.pi);
    canvas.drawCircle(Offset.zero, maxPhysicalRadius, sweepPaint);
    canvas.restore();

    // Paint 4: User active boundary ring
    final boundaryPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, activePhysicalRadius, boundaryPaint);

    // Breathing pulse ring at active boundary
    final pulsePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1 * (1.0 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0 + (12.0 * pulseValue);
    canvas.drawCircle(center, activePhysicalRadius, pulsePaint);

    // Paint 5: Mock Doctor positions inside the radar
    for (final offset in mockDoctorOffsets) {
      final physicalOffset = Offset(
        center.dx + offset.dx * maxPhysicalRadius,
        center.dy + offset.dy * maxPhysicalRadius,
      );

      final distanceKm = math.sqrt(offset.dx * offset.dx + offset.dy * offset.dy) * maxRadius;
      final isInside = distanceKm <= radiusKilometers;

      final dotPaint = Paint()
        ..color = isInside ? AppColors.success : Colors.grey.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(physicalOffset, isInside ? 5.0 : 3.0, dotPaint);

      if (isInside) {
        final glowPaint = Paint()
          ..color = AppColors.success.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(physicalOffset, 9.0, glowPaint);
      }
    }

    // Paint 6: Center user home coordinate pin
    final homePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6.0, homePaint);

    final homeOutline = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 6.0, homeOutline);
  }

  @override
  bool shouldRepaint(covariant DistanceRadiusPainter oldDelegate) {
    return oldDelegate.radiusKilometers != radiusKilometers ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.mockDoctorOffsets != mockDoctorOffsets;
  }
}

// ============================================================================
// 2. RATING ANALYTICS BAR CHART PAINTER
// ============================================================================

/// Custom painter to draw breakdown analytics of doctor ratings (5-star, 4-star, etc).
class ReviewBarChartPainter extends CustomPainter {
  final List<double> starDistribution; // Ratios for stars 5 down to 1
  final Color primaryColor;

  ReviewBarChartPainter({
    required this.starDistribution,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double labelWidth = 45.0;
    final double valueWidth = 35.0;
    final double barMaxWidth = size.width - labelWidth - valueWidth;
    final double rowHeight = size.height / 5;

    final bgBarPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final barPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final double yOffset = rowHeight * i + (rowHeight - 8) / 2;
      final int stars = 5 - i;

      // Draw star labels
      final labelSpan = TextSpan(
        text: '$stars Star',
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      );
      final labelPainter = TextPainter(text: labelSpan, textDirection: TextDirection.ltr)..layout();
      labelPainter.paint(canvas, Offset(0, yOffset - 3));

      // Draw background track bar
      final barX = labelWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(barX, yOffset, barMaxWidth, 8), const Radius.circular(4)),
        bgBarPaint,
      );

      // Draw progress value bar
      final double progressWidth = barMaxWidth * starDistribution[i].clamp(0.0, 1.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(barX, yOffset, progressWidth, 8), const Radius.circular(4)),
        barPaint,
      );

      // Draw value text percentage
      final valSpan = TextSpan(
        text: '${(starDistribution[i] * 100).toStringAsFixed(0)}%',
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      );
      final valPainter = TextPainter(text: valSpan, textDirection: TextDirection.ltr)..layout();
      valPainter.paint(canvas, Offset(barX + barMaxWidth + 8, yOffset - 3));
    }
  }

  @override
  bool shouldRepaint(covariant ReviewBarChartPainter oldDelegate) {
    return oldDelegate.starDistribution != starDistribution || oldDelegate.primaryColor != primaryColor;
  }
}

// ============================================================================
// 3. MAIN APPOINTMENTS HOME SCREEN
// ============================================================================

class AppointmentsHomeScreen extends ConsumerStatefulWidget {
  const AppointmentsHomeScreen({super.key});

  @override
  ConsumerState<AppointmentsHomeScreen> createState() => _AppointmentsHomeScreenState();
}

class _AppointmentsHomeScreenState extends ConsumerState<AppointmentsHomeScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = '';

  // Sort & Filter state variables
  double _radiusFilterKm = 8.0;
  String _selectedSortCriteria = 'Rating'; // Rating, Distance, Experience, Wait Time
  bool _filterOnlineOnly = false;
  double _maxConsultationFee = 2500.0;

  // Selected date slider
  int _selectedDateOffset = 0;

  // Radar Animation Controller
  late AnimationController _radarController;

  // Mock static coordinates for doctors on a 2D radial coordinate map
  final List<Offset> _mockDoctorCoordinates = const [
    Offset(-0.25, -0.42), // 5.2 km away
    Offset(0.35, 0.22),   // 4.1 km away
    Offset(-0.55, 0.45),  // 8.9 km away
    Offset(0.68, -0.62),  // 12.1 km away
    Offset(-0.12, 0.18),  // 2.3 km away
    Offset(0.48, -0.32),  // 6.8 km away
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  void _showDoctorDetailBottomSheet(Map<String, dynamic> doc) {
    final name = doc['name'] as String? ?? 'Doctor';
    final specialty = doc['specialization'] as String? ?? 'Specialist';
    final hospital = doc['hospital_name'] as String? ?? 'General Hospital';
    final ratingVal = doc['rating'] as num? ?? 4.8;
    final ratingStr = ratingVal.toStringAsFixed(1);
    final experience = (doc['experience_years'] as int? ?? 5).toString();

    // Create random mock ratings distribution representing stars 5 down to 1
    final listDistributions = [
      [0.72, 0.18, 0.06, 0.03, 0.01],
      [0.65, 0.20, 0.08, 0.05, 0.02],
      [0.80, 0.12, 0.05, 0.02, 0.01],
    ];
    final seedIndex = name.codeUnitAt(0) % listDistributions.length;
    final starDistribution = listDistributions[seedIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.82,
              maxChildSize: 0.90,
              minChildSize: 0.60,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bottom sheet drag handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Header Doctor Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              name.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  specialty,
                                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 14),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        hospital,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Doctor Stat Pill badges
                      Row(
                        children: [
                          Expanded(
                            child: _buildProfileStatBadge('Experience', '$experience Years', Icons.workspace_premium_rounded),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildProfileStatBadge('Rating Score', '$ratingStr ★', Icons.star_rounded, iconColor: Colors.amber),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildProfileStatBadge('Consultation', 'Rs. 1,500', Icons.payments_rounded, iconColor: Colors.green),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 28),

                      // Wait Time Estimate Analytics
                      Text(
                        'Live Wait Metrics',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                              child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average Queue Wait time is 18 minutes.',
                                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Predictive model accounts for midday peak and live reception check-ins.',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // RATING DISTRIBUTION CHART (CUSTOM PAINT)
                      Text(
                        'Patient Rating Distribution',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomPaint(
                          painter: ReviewBarChartPainter(
                            starDistribution: starDistribution,
                            primaryColor: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Professional reviews checklist tags
                      Text(
                        'Patient Feedback Highlights',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildReviewTag('Superb communication', Colors.blue),
                          _buildReviewTag('Short waiting times', Colors.green),
                          _buildReviewTag('Detailed consultation', Colors.purple),
                          _buildReviewTag('Extremely hygienic clinic', Colors.orange),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // Booking Action button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(selectedDoctorProvider.notifier).state = doc;
                            context.go('/doctor_detail');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Schedule Appointment Slot',
                            style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildReviewTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildProfileStatBadge(String label, String value, IconData icon, {Color iconColor = AppColors.primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(userHomeProvider);
    
    // Filter doctors locally based on search query, category, radius, and fee cap
    final filteredDoctors = homeState.doctors.where((doc) {
      final name = (doc['name'] as String? ?? '').toLowerCase();
      final specialty = (doc['specialization'] as String? ?? '').toLowerCase();
      
      final matchesSearch = name.contains(_searchQuery.toLowerCase()) || 
                            specialty.contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory.isEmpty || 
                              specialty == _selectedCategory.toLowerCase();

      // Check distance using mock assignment based on doctor name hash length
      final distanceVal = (name.length % 9) + 1.2; 
      final matchesRadius = distanceVal <= _radiusFilterKm;

      // Check consultation fee match
      final fee = (name.length % 3 == 0) ? 1500.0 : ((name.length % 3 == 1) ? 2000.0 : 2500.0);
      final matchesFee = fee <= _maxConsultationFee;

      return matchesSearch && matchesCategory && matchesRadius && matchesFee;
    }).toList();

    // Sort doctors based on selected sort criteria
    if (_selectedSortCriteria == 'Rating') {
      filteredDoctors.sort((a, b) {
        final rA = a['rating'] as num? ?? 4.8;
        final rB = b['rating'] as num? ?? 4.8;
        return rB.compareTo(rA); // Descending ratings
      });
    } else if (_selectedSortCriteria == 'Experience') {
      filteredDoctors.sort((a, b) {
        final eA = a['experience_years'] as int? ?? 5;
        final eB = b['experience_years'] as int? ?? 5;
        return eB.compareTo(eA); // Descending experience
      });
    } else if (_selectedSortCriteria == 'Distance') {
      filteredDoctors.sort((a, b) {
        final dA = (a['name'] as String? ?? '').length % 9;
        final dB = (b['name'] as String? ?? '').length % 9;
        return dA.compareTo(dB); // Ascending distance
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Premium Search Header Panel
            _buildSearchHeader(),

            // 2. Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(userHomeProvider.notifier).fetchDoctors(),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // A. Distance Radar Panel (Toggleable details)
                      _buildDistanceRadarSection(),

                      // B. Quick Schedule Date Select Slider
                      _buildDateSliderSection(),

                      // C. Filter Sort metrics bar
                      _buildSortingFilterBarSection(),

                      // D. Doctor List Content
                      homeState.isLoadingDoctors
                          ? _buildSkeletonLoaders()
                          : homeState.doctorError != null
                              ? _buildErrorWidget(homeState.doctorError!)
                              : filteredDoctors.isEmpty
                                  ? _buildEmptyState()
                                  : _buildDoctorsList(filteredDoctors),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 1),
    );
  }

  // Custom Search Header UI
  Widget _buildSearchHeader() {
    final categories = ['All', 'General', 'Cardiology', 'Pediatrics', 'Orthopedics', 'Neurology'];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/user_home'),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.background,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border, width: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Find Doctors',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          
          // Search Input Bar
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search doctors, specialties or hospitals...',
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary.withValues(alpha: 0.7)),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Badges List
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = (_selectedCategory.isEmpty && category == 'All') ||
                                   (_selectedCategory == category && category != 'All');

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category == 'All' ? '' : category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Distance Radar Filter Section
  Widget _buildDistanceRadarSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
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
                  'Distance Proximity Radar',
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                Text(
                  '${_radiusFilterKm.toStringAsFixed(1)} km radius',
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Animated Radar canvas
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: DistanceRadiusPainter(
                            radiusKilometers: _radiusFilterKm,
                            maxRadius: 15.0,
                            pulseValue: _radarController.value,
                            mockDoctorOffsets: _mockDoctorCoordinates,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Radius control slider
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Drag slider to expand query limits for nearby clinical consulting centers.',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Slider.adaptive(
                        value: _radiusFilterKm,
                        min: 2.0,
                        max: 15.0,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.border,
                        onChanged: (val) {
                          setState(() {
                            _radiusFilterKm = val;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Date selection slider
  Widget _buildDateSliderSection() {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Appointment Date',
            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = now.add(Duration(days: index));
                final dayLabel = index == 0 ? 'Today' : (index == 1 ? 'Tomorrow' : '${date.day}');
                final monthLabel = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1];
                final isSelected = index == _selectedDateOffset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateOffset = index;
                    });
                  },
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 0.8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          monthLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Sorting & Quick filters row panel
  Widget _buildSortingFilterBarSection() {
    final criteria = ['Rating', 'Distance', 'Experience'];

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.sort_rounded, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Sort by:',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: criteria.map((crit) {
              final isSelected = _selectedSortCriteria == crit;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSortCriteria = crit;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    crit,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Skeleton Loader for Doctor List Loading
  Widget _buildSkeletonLoaders() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 16, color: Colors.grey[200]),
                    const SizedBox(height: 8),
                    Container(width: 80, height: 12, color: Colors.grey[200]),
                    const SizedBox(height: 6),
                    Container(width: 140, height: 12, color: Colors.grey[200]),
                  ],
                ),
              ),
            ],
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: Colors.grey[100]);
      },
    );
  }

  // Error loading state
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Doctors',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(userHomeProvider.notifier).fetchDoctors(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text('Try Again', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
              child: const Icon(Icons.person_search_rounded, size: 54, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'No Doctors Found',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any doctors matching "$_searchQuery" inside a $_radiusFilterKm km radius. Try expanding your search.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  // Doctor List Widget
  Widget _buildDoctorsList(List<Map<String, dynamic>> doctors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doc = doctors[index];
        final name = doc['name'] as String? ?? 'Doctor';
        final specialty = doc['specialization'] as String? ?? 'Specialist';
        final hospital = doc['hospital_name'] as String? ?? 'General Hospital';
        final rating = (doc['rating'] as num? ?? 4.8).toStringAsFixed(1);
        final experience = (doc['experience_years'] as int? ?? 5).toString();

        // Distance value mock mapping based on name length
        final distanceVal = ((name.length % 9) + 1.2).toStringAsFixed(1);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  name.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              
              // Doctor Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.local_hospital_rounded, color: AppColors.textSecondary, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            hospital,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                              const SizedBox(width: 4),
                              Text(rating, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.amber[800])),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$experience Yrs • $distanceVal km away',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              
              // Book Action
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _showDoctorDetailBottomSheet(doc),
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.05, end: 0);
      },
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
