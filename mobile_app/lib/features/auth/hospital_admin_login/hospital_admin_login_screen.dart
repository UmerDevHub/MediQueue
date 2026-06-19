import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';

class HospitalAdminLoginScreen extends StatefulWidget {
  const HospitalAdminLoginScreen({super.key});

  @override
  State<HospitalAdminLoginScreen> createState() => _HospitalAdminLoginScreenState();
}

class _HospitalAdminLoginScreenState extends State<HospitalAdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    // Simulate API login
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // Save token (mocked) and route
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'mock_admin_jwt');
    await prefs.setString('role', 'hospital_admin');

    if (mounted) {
      context.go('/admin_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.apartment_outlined, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'MediQueue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Jinnah Hospital, Karachi',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.admin_panel_settings_outlined, size: 14, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'HOSPITAL ADMIN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Staff Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppInput(
                        label: 'EMAIL ADDRESS',
                        controller: _emailController,
                        hint: 'faisal.ahmed@jinnah.gov.pk',
                        prefixIcon: Icons.mail_outline,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AppInput(
                        label: 'PASSWORD',
                        controller: _passwordController,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Sign In',
                        icon: Icons.login,
                        isLoading: _isLoading,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 32),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                              color: AppColors.surface,
                            ),
                            child: const Icon(Icons.person, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Dr. Faisal Ahmed',
                                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Chief Medical Officer',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
