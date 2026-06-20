import 'package:flutter/material.dart';

class EmergencyResultScreen extends StatelessWidget {
  const EmergencyResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Result'),
      ),
      body: const Center(
        child: Text('Emergency Result Screen'),
      ),
    );
  }
}
