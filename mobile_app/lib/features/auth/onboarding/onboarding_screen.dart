import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme.dart';

// ---------------------------------------------------------------------------
// Custom Premium SVG Vectors matching the Screenshots
// ---------------------------------------------------------------------------
class OnboardingSvgs {
  // Slide 1: Book Easily (Calendar grid outline)
  static const String calendar = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
      <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
      <line x1="16" y1="2" x2="16" y2="6" />
      <line x1="8" y1="2" x2="8" y2="6" />
      <line x1="3" y1="10" x2="21" y2="10" />
    </svg>
  ''';

  // Slide 1 & 2: Track Live Queue / Live Queue Tracking (Solid two users silhouette)
  static const String people = '''
    <svg viewBox="0 0 24 24" fill="currentColor">
      <path d="M16.5 12c1.38 0 2.49-1.12 2.49-2.5S17.88 7 16.5 7C15.12 7 14 8.12 14 9.5s1.12 2.5 2.5 2.5zM9 11c1.66 0 2.99-1.34 2.99-3S10.66 5 9 5C7.34 5 6 6.34 6 8s1.34 3 3 3zm7.5 3c-1.83 0-5.5.92-5.5 2.75V19h11v-2.25c0-1.83-3.67-2.75-5.5-2.75zM9 13c-2.33 0-7 1.17-7 3.5V19h7v-2.25c0-.85.33-2.34 0-3.75z" />
    </svg>
  ''';

  // Slide 1: Secure & Reliable (Shield outline with a check inside)
  static const String shieldCheck = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      <polyline points="9 11 11 13 15 9" />
    </svg>
  ''';

  // Slide 2 & 3: Real-Time Updates / Smart Reminders (Solid bell clapper)
  static const String bell = '''
    <svg viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z" />
    </svg>
  ''';

  // Slide 2: Accurate Estimates (Clock outline with hands)
  static const String clock = '''
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="10" />
      <polyline points="12 6 12 12 16 14" />
    </svg>
  ''';

  // Slide 3: All in One Place (Folder overlayed with check icon)
  static const String folderShield = '''
    <svg viewBox="0 0 24 24" fill="currentColor">
      <path d="M20 6h-8l-2-2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-3 8.3c0 2.2-1.8 3.7-5 4.7-3.2-1-5-2.5-5-4.7V11l5-2 5 2v3.3z" />
    </svg>
  ''';

  // Slide 3: Secure & Private (Solid padlock outline)
  static const String padlock = '''
    <svg viewBox="0 0 24 24" fill="currentColor">
      <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z" />
    </svg>
  ''';
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<OnboardingData> _pages = [
    OnboardingData(
      titlePre: "Better Healthcare\nStarts ",
      titleHighlight: "Here",
      titlePost: "",
      description: "Book appointments, track queues in real-time and manage your healthcare effortlessly.",
      illustrationBuilder: (context) => const AppointmentIllustration(),
      features: [
        FeatureItem(
          svgData: OnboardingSvgs.calendar,
          title: "Book Easily",
          subtitle: "Find doctors and book appointments in seconds.",
        ),
        FeatureItem(
          svgData: OnboardingSvgs.people,
          title: "Track Live Queue",
          subtitle: "See your queue status and estimated wait time live.",
        ),
        FeatureItem(
          svgData: OnboardingSvgs.shieldCheck,
          title: "Secure & Reliable",
          subtitle: "Your data is safe with us. Always and everywhere.",
        ),
      ],
    ),
    OnboardingData(
      titlePre: "Track Your Queue\n",
      titleHighlight: "In Real-Time",
      titlePost: "",
      description: "Stay updated with your queue position, estimated wait time, and doctor availability.",
      illustrationBuilder: (context) => const QueueTrackerIllustration(),
      features: [
        FeatureItem(
          svgData: OnboardingSvgs.bell,
          title: "Real-Time Updates",
          subtitle: "Get instant updates about your queue status.",
        ),
        FeatureItem(
          svgData: OnboardingSvgs.people,
          title: "Live Queue Tracking",
          subtitle: "See how many people are ahead of you in the queue.",
        ),
        FeatureItem(
          svgData: OnboardingSvgs.clock,
          title: "Accurate Estimates",
          subtitle: "Know your estimated wait time and plan your day better.",
        ),
      ],
    ),
    OnboardingData(
      titlePre: "Manage Your\n",
      titleHighlight: "Healthcare Effortlessly",
      titlePost: "",
      description: "Access your appointments, medical history, prescriptions, and reports – all in one place.",
      illustrationBuilder: (context) => const SecureDoctorIllustration(),
      features: [
        FeatureItem(
          svgData: OnboardingSvgs.folderShield,
          title: "All in One Place",
          subtitle: "Access everything you need for your health in one app.",
          iconColor: AppColors.primary,
          bgColor: AppColors.primary.withValues(alpha: 0.08),
        ),
        FeatureItem(
          svgData: OnboardingSvgs.padlock,
          title: "Secure & Private",
          subtitle: "Your data is encrypted and protected with top-level security.",
          iconColor: AppColors.success,
          bgColor: AppColors.success.withValues(alpha: 0.08),
        ),
        FeatureItem(
          svgData: OnboardingSvgs.bell,
          title: "Smart Reminders",
          subtitle: "Never miss an appointment or important update.",
          iconColor: Colors.deepPurple,
          bgColor: Colors.deepPurple.withValues(alpha: 0.08),
        ),
      ],
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (mounted) {
      context.go('/role_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstPage = _currentPage == 0;
    final isLastPage = _currentPage == _pages.length - 1;

    return PopScope(
      canPop: isFirstPage,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              // Background Glow (top right)
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
              
              Column(
                children: [
                  // Top Header bar (dots/branding + Skip)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Dots Indicator: Shown at the top for Slide 2 and Slide 3
                          if (!isFirstPage)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  height: 8,
                                  width: _currentPage == index ? 24 : 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index 
                                      ? AppColors.primary 
                                      : AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          // Skip Button on the right (shown only on the first page)
                          if (isFirstPage)
                            Positioned(
                              right: 0,
                              child: TextButton(
                                onPressed: _completeOnboarding,
                                child: Text(
                                  'Skip',
                                  style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
  
                  // Sliding Main Content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        final item = _pages[index];
                        final isPage1 = index == 0;

                        // Build each slide according to its custom screenshot layout structure
                        if (isPage1) {
                          // Slide 1 Layout structure:
                          // - Logo Branding at the top
                          // - Illustration in the middle
                          // - Title & description below
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Top Center Brand Logo
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chat_bubble_rounded,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        const Positioned(
                                          top: 10,
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.primary,
                                            size: 16,
                                            weight: 4.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
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
                                    Text(
                                      'Smart Healthcare. Zero Waiting.',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Illustration in middle
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        width: 270,
                                        height: 260,
                                        child: Center(
                                          child: item.illustrationBuilder(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Title & Description below
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.titlePre,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.titleHighlight,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.titlePost,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        } else {
                          // Slide 2 & 3 Layout structure:
                          // - Title & description at the top
                          // - Illustration in the middle
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Title & Description at the top
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.titlePre,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.titleHighlight,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.titlePost,
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Illustration in middle
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        width: 270,
                                        height: 260,
                                        child: Center(
                                          child: item.illustrationBuilder(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
  
                  // Features indicators & bottom actions (placed below PageView content)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 3 Features indicators: Column/Cards based on Slide design
                        FeaturesRow(
                          features: _pages[_currentPage].features,
                          useCardStyle: !isFirstPage, // Slide 2 & 3 use white card backgrounds
                        ),
                        const SizedBox(height: 16),
                        
                        // Slide 1 Bottom Dots Indicator (only at bottom for page 1)
                        if (isFirstPage) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                height: 8,
                                width: _currentPage == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == index 
                                    ? AppColors.primary 
                                    : AppColors.border,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Main Actions Row: [Back / Skip] & [Next]
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isFirstPage 
                                  ? _completeOnboarding 
                                  : () {
                                      _pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!isFirstPage) ...[
                                      const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      isFirstPage ? 'Skip' : 'Back',
                                      style: GoogleFonts.inter(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLastPage 
                                  ? _completeOnboarding 
                                  : () {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Bottom "Get Started" full-width button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _completeOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFirstPage
                                  ? AppColors.primary 
                                  : AppColors.primary.withValues(alpha: 0.1),
                              foregroundColor: isFirstPage
                                  ? Colors.white
                                  : AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
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
      ),
    );
  }
}

class OnboardingData {
  final String titlePre;
  final String titleHighlight;
  final String titlePost;
  final String description;
  final WidgetBuilder illustrationBuilder;
  final List<FeatureItem> features;

  OnboardingData({
    required this.titlePre,
    required this.titleHighlight,
    required this.titlePost,
    required this.description,
    required this.illustrationBuilder,
    required this.features,
  });
}

class FeatureItem {
  final String svgData;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? bgColor;

  FeatureItem({
    required this.svgData,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.bgColor,
  });
}

// ---------------------------------------------------------------------------
// Custom Mockup Illustrations
// ---------------------------------------------------------------------------

class AppointmentIllustration extends StatelessWidget {
  const AppointmentIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main coded mockup container
        Container(
          width: 190,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMuted.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Blue banner header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Booking Portal',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Confirmation Widget
              Positioned(
                top: 62,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Confirmed',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                  fontSize: 11,
                              ),
                            ),
                            Text(
                              'Dr. Farhan',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Time badge & Details
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time:',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '10:30 AM',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Vector icons representing options
                    Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_pharmacy, color: AppColors.primary, size: 18),
                            SizedBox(width: 12),
                            Icon(Icons.medical_services_rounded, color: AppColors.textSecondary, size: 18),
                            SizedBox(width: 12),
                            Icon(Icons.healing_rounded, color: AppColors.textSecondary, size: 18),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // Overlay actual png cartoon characters illustration (if file is dropped in assets)
        Positioned(
          left: -40,
          bottom: -10,
          child: Image.asset(
            'assets/images/onboarding_1.png',
            height: 190,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),
      ],
    );
  }
}

class QueueTrackerIllustration extends StatelessWidget {
  const QueueTrackerIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main coded mockup phone container
        Container(
          width: 190,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMuted.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Live Queue',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications_none, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // Big Token Card
              Positioned(
                top: 60,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Queue Number',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '23',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '12 People Ahead',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Estimated Wait Card
              Positioned(
                top: 145,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppColors.success, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Wait Time',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '25-30m',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Queue progress line
              Positioned(
                bottom: 10,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Queue Progress',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildProgressStep("Waiting", true),
                          _buildProgressStep("Serving", false),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        // Overlay actual png cartoon characters illustration (if file is dropped in assets)
        Positioned(
          right: -40,
          bottom: -10,
          child: Image.asset(
            'assets/images/onboarding_2.png',
            height: 190,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressStep(String label, bool active) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class SecureDoctorIllustration extends StatelessWidget {
  const SecureDoctorIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main coded mockup container
        Container(
          width: 190,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMuted.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'My Health',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.settings, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // User profile banner
              Positioned(
                top: 48,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white, size: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Sarah',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Manage records.',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // White Cards List
              Positioned(
                top: 86,
                left: 8,
                right: 8,
                bottom: 30,
                child: Column(
                  children: [
                    _buildMenuItem(Icons.calendar_month, 'Appointments', '2 Upcoming'),
                    _buildMenuItem(Icons.folder_shared, 'Medical History', 'Records'),
                    _buildMenuItem(Icons.link, 'Prescriptions', '3 Active'),
                    _buildMenuItem(Icons.description, 'Reports', 'View lab reports'),
                  ],
                ),
              ),
              // Bottom Navigation preview bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, color: AppColors.primary, size: 12),
                      Icon(Icons.calendar_month, color: AppColors.textSecondary, size: 12),
                      Icon(Icons.people_alt, color: AppColors.textSecondary, size: 12),
                      Icon(Icons.notifications, color: AppColors.textSecondary, size: 12),
                      Icon(Icons.person, color: AppColors.textSecondary, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Overlay actual png cartoon characters illustration (if file is dropped in assets)
        Positioned(
          left: -40,
          bottom: -10,
          child: Image.asset(
            'assets/images/onboarding_3.png',
            height: 190,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String sub) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 12),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 8.5, 
                      fontWeight: FontWeight.w700, 
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    sub,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 6.5, 
                      color: AppColors.textSecondary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 8, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3 Icon Indicators with detailed captions
// ---------------------------------------------------------------------------

class FeaturesRow extends StatelessWidget {
  final List<FeatureItem> features;
  final bool useCardStyle;

  const FeaturesRow({
    super.key,
    required this.features,
    required this.useCardStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((item) => _buildFeatureItem(item)).toList(),
    );
  }

  Widget _buildFeatureItem(FeatureItem item) {
    final activeIconColor = item.iconColor ?? AppColors.primary;
    final activeBgColor = item.bgColor ?? AppColors.primary.withValues(alpha: 0.08);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: activeBgColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.string(
            item.svgData,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(activeIconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 9,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );

    if (useCardStyle) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: content,
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: content,
        ),
      );
    }
  }
}
