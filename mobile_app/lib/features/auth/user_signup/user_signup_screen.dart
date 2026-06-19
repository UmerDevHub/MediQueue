import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key? key}) : super(key: key);

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {'full_name': _nameController.text.trim(), 'role': 'user'}, // Domain logic: defaulting to generic 'user'
      );
      
      if (res.session != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', res.session!.accessToken);
        if (mounted) context.go('/user_home');
      } else {
        // If email confirmation is required, handle it here
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check your email to confirm registration.')));
           context.go('/user_login');
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.medical_services, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              const Text('MediQueue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              const Text('Clinical management simplified.', style: TextStyle(color: Color(0xFF475569))),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create your account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 24),
                    _buildInputLabel('FULL NAME'),
                    _buildTextField('Ahmed Khan', controller: _nameController),
                    const SizedBox(height: 16),
                    _buildInputLabel('PHONE NUMBER'),
                    _buildTextField('03XX-XXXXXXX'),
                    const SizedBox(height: 16),
                    _buildInputLabel('EMAIL ADDRESS'),
                    _buildTextField('ahmed@hospital.pk', controller: _emailController),
                    const SizedBox(height: 16),
                    _buildInputLabel('PASSWORD'),
                    _buildTextField('••••••••', obscureText: true, controller: _passwordController),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 16),
                      child: Text('Password must be at least 8 characters', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    ),
                    _buildInputLabel('CONFIRM PASSWORD'),
                    _buildTextField('••••••••', obscureText: true),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC), // Slightly darker blue from design
                        minimumSize: const Size(double.infinity, 56),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: Color(0xFF475569))),
                        GestureDetector(
                          onTap: () => context.go('/user_login'),
                          child: const Text('Sign in', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'By signing up, you agree to the Terms of Service and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('POWERED BY MEDIQUEUE HEALTH SYSTEMS', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155), letterSpacing: 1)),
    );
  }

  Widget _buildTextField(String hint, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}
