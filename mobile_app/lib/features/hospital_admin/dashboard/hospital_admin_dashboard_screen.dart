import 'package:flutter/material.dart';

class HospitalAdminDashboardScreen extends StatelessWidget {
  const HospitalAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Admin Dashboard'),
      ),
      body: const Center(
        child: Text('Hospital Admin Dashboard Screen'),
      ),
    );
  }
}
