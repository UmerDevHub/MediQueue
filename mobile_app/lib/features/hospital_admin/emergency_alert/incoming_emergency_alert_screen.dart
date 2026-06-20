import 'package:flutter/material.dart';

class IncomingEmergencyAlertScreen extends StatelessWidget {
  const IncomingEmergencyAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Emergency Alert'),
      ),
      body: const Center(
        child: Text('Incoming Emergency Alert Screen'),
      ),
    );
  }
}
