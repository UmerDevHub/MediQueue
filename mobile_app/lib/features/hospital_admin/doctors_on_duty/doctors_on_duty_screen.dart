import 'package:flutter/material.dart';

class DoctorsOnDutyScreen extends StatelessWidget {
  const DoctorsOnDutyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors On Duty'),
      ),
      body: const Center(
        child: Text('Doctors On Duty Screen'),
      ),
    );
  }
}
