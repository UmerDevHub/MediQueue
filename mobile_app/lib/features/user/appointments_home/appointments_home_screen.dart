import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../providers/user_home_provider.dart';
import '../providers/booking_provider.dart';

class AppointmentsHomeScreen extends ConsumerStatefulWidget {
  const AppointmentsHomeScreen({super.key});

  @override
  ConsumerState<AppointmentsHomeScreen> createState() => _AppointmentsHomeScreenState();
}

class _AppointmentsHomeScreenState extends ConsumerState<AppointmentsHomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(userHomeProvider);
    
    // Filter doctors locally based on search query and category
    final filteredDoctors = homeState.doctors.where((doc) {
      final name = (doc['name'] as String? ?? '').toLowerCase();
      final specialty = (doc['specialization'] as String? ?? '').toLowerCase();
      
      final matchesSearch = name.contains(_searchQuery.toLowerCase()) || 
                            specialty.contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory.isEmpty || 
                              specialty == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Premium Search Header Panel
            _buildSearchHeader(),

            // 2. Doctor List Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(userHomeProvider.notifier).fetchDoctors(),
                color: AppColors.primary,
                child: homeState.isLoadingDoctors
                    ? _buildSkeletonLoaders()
                    : homeState.doctorError != null
                        ? _buildErrorWidget(homeState.doctorError!)
                        : filteredDoctors.isEmpty
                            ? _buildEmptyState()
                            : _buildDoctorsList(filteredDoctors),
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

  // Skeleton Loader for Doctor List Loading
  Widget _buildSkeletonLoaders() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
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
                'We couldn\'t find any doctors matching "$_searchQuery". Try refining your search terms or specialty filter.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Doctor List Widget
  Widget _buildDoctorsList(List<Map<String, dynamic>> doctors) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doc = doctors[index];
        final name = doc['name'] as String? ?? 'Doctor';
        final specialty = doc['specialization'] as String? ?? 'Specialist';
        final hospital = doc['hospital_name'] as String? ?? 'General Hospital';
        final rating = (doc['rating'] as num? ?? 4.8).toStringAsFixed(1);
        final experience = (doc['experience_years'] as int? ?? 5).toString();

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
                          '$experience Yrs Exp',
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
                    onPressed: () {
                      ref.read(selectedDoctorProvider.notifier).state = doc;
                      context.go('/doctor_detail');
                    },
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
