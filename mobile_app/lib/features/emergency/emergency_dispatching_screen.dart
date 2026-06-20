import 'package:flutter/material.dart';

class EmergencyDispatchingScreen extends StatelessWidget {
  const EmergencyDispatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Dispatching'),
      ),
      body: const Center(
        child: Text('Emergency Dispatching Screen'),
      ),
    );
  }
}
