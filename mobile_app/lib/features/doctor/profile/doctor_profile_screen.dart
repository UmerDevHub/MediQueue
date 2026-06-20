import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';

class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  ConsumerState<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends ConsumerState<DoctorProfileScreen> {
  bool _isLoggingOut = false;

  // Consulting setup preferences (can be toggled locally)
  int _consultationFee = 1500;
  int _maxPatientsPerHour = 4;

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.logout_rounded, color: AppColors.danger, size: 24),
              const SizedBox(width: 10),
              Text('Log Out', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          content: Text(
            'Are you sure you want to log out of the doctor portal? Patients will no longer see you as active in the OPD queue.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final router = GoRouter.of(context);
                Navigator.pop(context);
                setState(() {
                  _isLoggingOut = true;
                });
                
                await ref.read(authProvider.notifier).logout();
                if (mounted) {
                  setState(() {
                    _isLoggingOut = false;
                  });
                  router.go('/role_selection');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                'Log Out',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final docName = authState.user?.name ?? 'Dr. Aisha Khan';
    final docEmail = authState.user?.email ?? 'dr.aisha@mediqueue.com';
    final docPhone = authState.user?.phone ?? '+92 300 9876543';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title Row
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Doctor Profile',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Avatar Block
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      docName.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 14),

                  // Doctor Name and Designation Tag
                  Text(
                    docName,
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'OPD GENERAL MEDICINE',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Stats row
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('8 Yrs', 'Experience')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('4.9 ★', 'Patient Rating')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('180+', 'Consultations')),
                    ],
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 28),

                  // personal clinical details
                  _buildSectionLabel('Clinical Identity'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(Icons.alternate_email_rounded, 'Clinical Email', docEmail),
                        const Divider(height: 1, color: AppColors.border),
                        _buildInfoTile(Icons.phone_iphone_rounded, 'Mobile Contact', docPhone),
                        const Divider(height: 1, color: AppColors.border),
                        _buildInfoTile(Icons.medical_information_outlined, 'License Registry', 'MQ-DOC-98219'),
                        const Divider(height: 1, color: AppColors.border),
                        _buildInfoTile(Icons.home_work_outlined, 'Clinic Location', 'Mayo Hospital, Hall B, Room 3B'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 24),

                  // consultation preferences section
                  _buildSectionLabel('Consultation Setup'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Consultation Fee',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Charge rate per booked patient slot',
                                  style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            DropdownButton<int>(
                              value: _consultationFee,
                              underline: const SizedBox.shrink(),
                              items: const [
                                DropdownMenuItem(value: 1000, child: Text('Rs. 1,000')),
                                DropdownMenuItem(value: 1500, child: Text('Rs. 1,500')),
                                DropdownMenuItem(value: 2000, child: Text('Rs. 2,000')),
                                DropdownMenuItem(value: 2500, child: Text('Rs. 2,500')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _consultationFee = val;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hourly Patient Cap',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Maximum check-ins served per hour',
                                  style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            DropdownButton<int>(
                              value: _maxPatientsPerHour,
                              underline: const SizedBox.shrink(),
                              items: const [
                                DropdownMenuItem(value: 3, child: Text('3 Patients/hr')),
                                DropdownMenuItem(value: 4, child: Text('4 Patients/hr')),
                                DropdownMenuItem(value: 5, child: Text('5 Patients/hr')),
                                DropdownMenuItem(value: 6, child: Text('6 Patients/hr')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _maxPatientsPerHour = val;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: 28),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _showLogoutConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger.withValues(alpha: 0.08),
                        foregroundColor: AppColors.danger,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Log Out Portal Session',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (_isLoggingOut)
              Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildDoctorBottomNavBar(context, 2),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 14),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
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
      ),
    );
  }

  Widget _buildDoctorBottomNavBar(BuildContext context, int activeIndex) {
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
                context.go('/doctor_home');
                break;
              case 1:
                context.go('/my_schedule');
                break;
              case 2:
                context.go('/doctor_profile');
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Console'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'My Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
