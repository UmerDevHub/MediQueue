import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('MediQueue', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => context.go('/role_selection'),
            child: const Text('SKIP', style: TextStyle(color: Color(0xFF64748B), letterSpacing: 1)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPageContent(
                      icon: Icons.emergency,
                      title: 'Find nearest hospital instantly',
                      description: 'Access real-time medical facility data to locate the closest emergency care during critical moments.',
                    ),
                    _buildPageContent(
                      icon: Icons.local_hospital,
                      title: 'Real-time Wait Times',
                      description: 'Avoid overcrowded ERs by checking live queue predictions powered by advanced ML algorithms.',
                    ),
                    _buildPageContent(
                      icon: Icons.health_and_safety,
                      title: 'Seamless Care Coordination',
                      description: 'Book appointments instantly and securely manage your medical records in one unified ecosystem.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(_currentPage == 0),
                  const SizedBox(width: 8),
                  _buildDot(_currentPage == 1),
                  const SizedBox(width: 8),
                  _buildDot(_currentPage == 2),
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < 2) {
                    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  } else {
                    context.go('/role_selection');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_currentPage == 2 ? 'GET STARTED' : 'NEXT', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent({required IconData icon, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
          child: Center(
            child: Icon(icon, size: 100, color: const Color(0xFF94A3B8)),
          ),
        ),
        const SizedBox(height: 48),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF475569), fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
        shape: BoxShape.circle,
      ),
    );
  }
}
