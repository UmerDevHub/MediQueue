import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme.dart';

// ---------------------------------------------------------------------------
// Premium SVG Icons matching the Screenshot
// ---------------------------------------------------------------------------
class RoleSvgs {
  // Stethoscope inside blue shield + pulse heart badge
  static const String patientAvatar = '''
    <svg viewBox="0 0 64 64" fill="none">
      <circle cx="32" cy="32" r="30" fill="#2563EB" fill-opacity="0.06" />
      <path d="M32 12L16 18v18c0 10 6.9 19.2 16 21.3 9.1-2.1 16-11.3 16-21.3V18l-16-6z" fill="#2563EB" />
      <!-- Stethoscope -->
      <path d="M26 26v4c0 3.3 2.7 6 6 6s6-2.7 6-6v-4" stroke="white" stroke-width="2.5" stroke-linecap="round" />
      <circle cx="26" cy="24" r="3.5" stroke="white" stroke-width="2" />
      <circle cx="38" cy="24" r="3.5" stroke="white" stroke-width="2" />
      <path d="M32 36v8" stroke="white" stroke-width="2.5" stroke-linecap="round" />
      <circle cx="32" cy="46" r="3" fill="white" />
      
      <!-- Heart badge overlay bottom right -->
      <circle cx="48" cy="48" r="9" fill="#2563EB" stroke="white" stroke-width="2" />
      <path d="M48 51.5c-2.2 0-4-1.8-4-4 0-2.8 4-6 4-6s4 3.2 4 6c0 2.2-1.8 4-4 4z" fill="white" />
    </svg>
  ''';

  // Stethoscope on the left + doctor silhouette on the right
  static const String doctorAvatar = '''
    <svg viewBox="0 0 64 64" fill="none">
      <circle cx="32" cy="32" r="30" fill="#2563EB" fill-opacity="0.06" />
      <!-- Doctor icon on the right -->
      <g transform="translate(8, 0)">
        <circle cx="32" cy="24" r="7" fill="#2563EB" />
        <path d="M18 46c0-7.7 6.3-14 14-14s14 6.3 14 14" fill="#2563EB" />
        <path d="M27 32l5 6 5-6" fill="white" />
      </g>
      <!-- Stethoscope on the left -->
      <path d="M18 22v12c0 4.4 3.6 8 8 8" stroke="#2563EB" stroke-width="2.5" stroke-linecap="round" />
      <circle cx="18" cy="20" r="3.5" stroke="#2563EB" stroke-width="2" />
      <circle cx="26" cy="42" r="3" fill="#2563EB" />
    </svg>
  ''';

  // Hospital building with cross + shield pulse bottom right
  static const String adminAvatar = '''
    <svg viewBox="0 0 64 64" fill="none">
      <circle cx="32" cy="32" r="30" fill="#2563EB" fill-opacity="0.06" />
      <!-- Hospital building -->
      <path d="M16 46V22h32v24H16z" fill="#2563EB" fill-opacity="0.15" />
      <path d="M26 46V16h12v30H26z" fill="#2563EB" />
      <!-- Medical Cross -->
      <path d="M32 20v6M29 23h6" stroke="white" stroke-width="2.5" stroke-linecap="round" />
      <!-- Windows -->
      <rect x="20" y="26" width="4" height="4" rx="1" fill="#2563EB" />
      <rect x="20" y="34" width="4" height="4" rx="1" fill="#2563EB" />
      <rect x="40" y="26" width="4" height="4" rx="1" fill="#2563EB" />
      <rect x="40" y="34" width="4" height="4" rx="1" fill="#2563EB" />
      <!-- Door -->
      <path d="M30 46v-6h4v6h-4z" fill="white" />
      <!-- Shield on bottom right -->
      <path d="M48 36l-6 2v5c0 3.7 2.6 7.2 6 8 3.4-.8 6-4.3 6-8v-5l-6-2z" fill="#2563EB" stroke="white" stroke-width="1.5" />
      <!-- Heartbeat/pulse line inside the shield -->
      <path d="M45 44h2.5l1.5-3 1.5 5 1.5-2h2" stroke="white" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
  ''';

  // Trust Badges SVGs (Outlined)
  static const String secure = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      <polyline points="9 11 11 13 15 9" />
    </svg>
  ''';

  static const String privateLock = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
      <path d="M7 11V7a5 5 0 0 1 10 0v4" />
    </svg>
  ''';

  static const String reliable = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="10" />
      <polyline points="8 12 11 15 16 9" />
    </svg>
  ''';
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'patient';

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _handleContinue() {
    // Navigate based on selected role
    if (_selectedRole == 'patient') {
      context.go('/user_login');
    } else if (_selectedRole == 'doctor') {
      context.go('/doctor_login');
    } else if (_selectedRole == 'admin') {
      context.go('/hospital_admin_login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                
                // MediQueue Header Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const Positioned(
                          top: 10,
                          child: Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 14,
                            weight: 4.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Medi',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'Queue',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 28),
                
                // Title and subtitle
                Text(
                  'Choose Your Role',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your portal to continue',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 28),
                
                // Role Selection Cards
                _buildRoleCard(
                  id: 'patient',
                  title: 'Patient',
                  subtitle: 'Book appointments &\ntrack queues live',
                  svgData: RoleSvgs.patientAvatar,
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  id: 'doctor',
                  title: 'Doctor',
                  subtitle: 'Manage schedules &\nview patient history',
                  svgData: RoleSvgs.doctorAvatar,
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  id: 'admin',
                  title: 'Hospital Admin',
                  subtitle: 'Manage queues &\nemergency dispatch',
                  svgData: RoleSvgs.adminAvatar,
                ),
                
                const SizedBox(height: 28),
                
                // Trust Badges Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTrustBadge(
                        iconSvg: RoleSvgs.secure,
                        title: 'Secure',
                        subtitle: 'Your data is safe\nwith us',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.border,
                    ),
                    Expanded(
                      child: _buildTrustBadge(
                        iconSvg: RoleSvgs.privateLock,
                        title: 'Private',
                        subtitle: 'HIPAA compliant\n& encrypted',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.border,
                    ),
                    Expanded(
                      child: _buildTrustBadge(
                        iconSvg: RoleSvgs.reliable,
                        title: 'Reliable',
                        subtitle: '24/7 support\navailable',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Already Registered Outlined Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/user_login');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already Registered? ',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String id,
    required String title,
    required String subtitle,
    required String svgData,
  }) {
    final isSelected = _selectedRole == id;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => _onRoleSelected(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected 
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.02),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar circle containing premium vector
                SizedBox(
                  width: 64,
                  height: 64,
                  child: SvgPicture.string(
                    svgData,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Right side button indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Selected Checkmark Badge overlay
        if (isSelected)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrustBadge({
    required String iconSvg,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.string(
          iconSvg,
          width: 18,
          height: 18,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
