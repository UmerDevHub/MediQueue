import 'package:flutter/material.dart';

class LiveQueueTrackerScreen extends StatelessWidget {
  const LiveQueueTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Queue Tracker'),
      ),
      body: const Center(
        child: Text('Live Queue Tracker Screen'),
      ),
    );
  }
}
