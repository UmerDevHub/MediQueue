import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../../../core/config.dart';

class EmergencyTriggerScreen extends StatefulWidget {
  const EmergencyTriggerScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyTriggerScreen> createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> {
  final _symptomsController = TextEditingController();
  double _severityLevel = 5.0;
  bool _requestAmbulance = true;
  bool _isDispatching = false;
  Position? _currentPosition;
  String _locationStatus = 'Detecting location...';

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationStatus = 'Location services disabled');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationStatus = 'Location permission denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationStatus = 'Location permanently denied');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _locationStatus =
            '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E  ● Located';
      });
    } catch (e) {
      setState(() => _locationStatus = 'Error: ${e.toString()}');
    }
  }

  Future<void> _dispatchEmergency() async {
    if (_symptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your symptoms.')),
      );
      return;
    }
    setState(() => _isDispatching = true);
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null || session == null) {
        context.go('/role_selection');
        return;
      }

      final lat = _currentPosition?.latitude ?? 24.8607;
      final lng = _currentPosition?.longitude ?? 67.0011;

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/api/v1/emergency/dispatch'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'user_id': user.id,
          'symptoms': _symptomsController.text.trim(),
          'severity': _severityLevel.toInt(),
          'requires_ambulance': _requestAmbulance,
          'location_lat': lat,
          'location_lng': lng,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) context.go('/emergency_dispatching');
      } else {
        final error = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dispatch failed: ${error['detail'] ?? response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDispatching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB91C1C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Describe Your Emergency',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EMERGENCY DETAILS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _symptomsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe your symptoms...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SEVERITY LEVEL',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                Text('${_severityLevel.toInt()}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C))),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Slider(
                    value: _severityLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: const Color(0xFFB91C1C),
                    inactiveColor: const Color(0xFF86EFAC),
                    onChanged: (val) => setState(() => _severityLevel = val),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mild', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      Text('Moderate', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      Text('Critical', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.airport_shuttle, color: Color(0xFFB91C1C), size: 32),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request Immediate Ambulance',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        Text('Dispatch nearest emergency vehicle',
                            style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
                      ],
                    ),
                  ),
                  Switch(
                    value: _requestAmbulance,
                    onChanged: (val) => setState(() => _requestAmbulance = val),
                    activeColor: const Color(0xFFB91C1C),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('AUTO-DETECTED LOCATION',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(
                      child: _currentPosition == null
                          ? const CircularProgressIndicator(color: Colors.greenAccent)
                          : const Icon(Icons.location_on, color: Colors.greenAccent, size: 48),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_locationStatus, style: const TextStyle(color: Color(0xFF0F172A)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: Color(0xFF991B1B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This will trigger an immediate emergency alert to the nearest MediQueue facility and dispatch emergency responders if selected.',
                      style: TextStyle(color: Color(0xFF991B1B), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isDispatching ? null : _dispatchEmergency,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isDispatching
                ? const CircularProgressIndicator(color: Colors.white)
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sensors, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Dispatch Emergency',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
