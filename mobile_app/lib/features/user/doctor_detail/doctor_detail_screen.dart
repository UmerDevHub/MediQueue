import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Detail'),
      ),
      body: const Center(
        child: Text('Doctor Detail Screen'),
      ),
    );
  }
}
