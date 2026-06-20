import 'package:flutter/material.dart';

class EmergencyTriggerScreen extends StatelessWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Trigger'),
      ),
      body: const Center(
        child: Text('Emergency Trigger Screen'),
      ),
    );
  }
}
