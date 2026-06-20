import 'package:flutter/material.dart';

class HospitalAdminLoginScreen extends StatelessWidget {
  const HospitalAdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Admin Login'),
      ),
      body: const Center(
        child: Text('Hospital Admin Login Screen'),
      ),
    );
  }
}
