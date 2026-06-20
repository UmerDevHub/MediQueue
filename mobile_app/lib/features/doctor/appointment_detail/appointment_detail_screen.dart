import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Detail'),
      ),
      body: Center(
        child: Text('Appointment Detail Screen (ID: $appointmentId)'),
      ),
    );
  }
}
