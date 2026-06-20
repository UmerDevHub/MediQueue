import 'package:flutter/material.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Login'),
      ),
      body: const Center(
        child: Text('Doctor Login Screen'),
      ),
    );
  }
}
