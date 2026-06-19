import 'package:flutter/material.dart';

class HospitalAdminLoginScreen extends StatefulWidget {
  const HospitalAdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<HospitalAdminLoginScreen> createState() => _HospitalAdminLoginScreenState();
}

class _HospitalAdminLoginScreenState extends State<HospitalAdminLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.business, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 24),
                      const Text('MediQueue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 8),
                      const Text('Jinnah Hospital, Karachi', style: TextStyle(color: Color(0xFF475569))),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.shield_outlined, size: 14, color: Color(0xFF3730A3)),
                            SizedBox(width: 8),
                            Text('HOSPITAL ADMIN', style: TextStyle(color: Color(0xFF3730A3), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text('Staff Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EMAIL ADDRESS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155), letterSpacing: 1)),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'faisal.ahmed@jinnah.gov.pk',
                              suffixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB))),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text('PASSWORD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155), letterSpacing: 1)),
                          const SizedBox(height: 8),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              suffixIcon: const Icon(Icons.visibility_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB))),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              minimumSize: const Size(double.infinity, 56),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.login, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Dr. Faisal Ahmed', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('Chief Medical Officer', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.verified_user_outlined, color: Color(0xFF94A3B8), size: 20),
                        SizedBox(width: 8),
                        Text('HIPAA\nCOMPLIANT', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, height: 1.2)),
                      ],
                    ),
                    const SizedBox(width: 48),
                    Row(
                      children: const [
                        Icon(Icons.security, color: Color(0xFF94A3B8), size: 20),
                        SizedBox(width: 8),
                        Text('256-BIT AES\nSECURITY', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, height: 1.2)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
