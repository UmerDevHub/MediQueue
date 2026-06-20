import 'package:flutter/material.dart';

class UserSignupScreen extends StatelessWidget {
  const UserSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Signup'),
      ),
      body: const Center(
        child: Text('User Signup Screen'),
      ),
    );
  }
}
