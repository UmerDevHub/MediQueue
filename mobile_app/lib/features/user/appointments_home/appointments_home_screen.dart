import 'package:flutter/material.dart';

class AppointmentsHomeScreen extends StatelessWidget {
  const AppointmentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments Home'),
      ),
      body: const Center(
        child: Text('Appointments Home Screen'),
      ),
    );
  }
}
