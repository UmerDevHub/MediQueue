import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveQueueTrackerScreen extends StatefulWidget {
  const LiveQueueTrackerScreen({Key? key}) : super(key: key);

  @override
  State<LiveQueueTrackerScreen> createState() => _LiveQueueTrackerScreenState();
}

class _LiveQueueTrackerScreenState extends State<LiveQueueTrackerScreen> {
  int _queuePos = 0;
  String _status = 'loading';
  String _hospitalName = '—';
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _loadInitialQueue();
    _listenToQueueUpdates();
  }

  @override
  void dispose() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
    }
    super.dispose();
  }

  Future<void> _loadInitialQueue() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      final res = await Supabase.instance.client
          .from('queue')
          .select('queue_position, status, hospitals(name)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (mounted && res != null) {
        setState(() {
          _queuePos = res['queue_position'] ?? 0;
          _status = res['status'] ?? 'accepted';
          _hospitalName = (res['hospitals'] as Map?)?['name'] ?? 'Assigning...';
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _listenToQueueUpdates() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    _channel = Supabase.instance.client
        .channel('queue-tracker-${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'queue',
          filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq, column: 'user_id', value: user.id),
          callback: (payload) {
            if (mounted) {
              setState(() {
                _queuePos = payload.newRecord['queue_position'] ?? _queuePos;
                _status = payload.newRecord['status'] ?? _status;
              });
            }
          },
        )
        .subscribe();
  }

  String _ordinal(int n) {
    if (n == 1) return '1st';
    if (n == 2) return '2nd';
    if (n == 3) return '3rd';
    return '${n}th';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned(
            top: 0, left: 0, right: 0, bottom: 300,
            child: Container(
              color: const Color(0xFF1E293B),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.map, color: Colors.grey.withOpacity(0.2), size: 300)),
                  Positioned(
                    top: 150,
                    right: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFB91C1C), shape: BoxShape.circle),
                          child: const Icon(Icons.local_hospital, color: Colors.white),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Text(_hospitalName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 100,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
                          child: const Icon(Icons.airport_shuttle, color: Colors.white),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: const Text('En Route',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
          // Bottom Sheet
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 360,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.circle, color: Color(0xFFDC2626), size: 12),
                            SizedBox(width: 8),
                            Text('UPDATING LIVE...',
                                style: TextStyle(
                                    color: Color(0xFF334155),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Queue Progress',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Text(_hospitalName,
                                    style: const TextStyle(color: Color(0xFF475569))),
                              ],
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF2563EB), width: 4),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_queuePos > 0 ? _ordinal(_queuePos) : '—',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2563EB))),
                                    const Text('POS',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildTimelineItem(
                          isCompleted: true,
                          title: 'Accepted',
                          subtitle: 'Your request has been prioritized.',
                          time: 'Done',
                          isActive: false,
                        ),
                        _buildTimelineItem(
                          isCompleted: _status == 'en_route' || _status == 'arrived',
                          title: 'En Route',
                          subtitle: 'Ambulance dispatched to your location.',
                          time: 'Active',
                          isActive: _status == 'en_route',
                        ),
                        _buildTimelineItem(
                          isCompleted: _status == 'arrived',
                          title: 'Arrived',
                          subtitle: _status == 'arrived' ? 'Hospital reached' : 'Pending...',
                          time: '',
                          isActive: false,
                          isLast: true,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required bool isCompleted,
    required String title,
    required String subtitle,
    required String time,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? const Color(0xFFDBEAFE) : Colors.transparent,
                border: Border.all(
                    color: isCompleted ? const Color(0xFF2563EB) : Colors.grey.shade400, width: 2),
              ),
              child: Icon(Icons.circle,
                  size: 10, color: isCompleted ? const Color(0xFF2563EB) : Colors.transparent),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted && !isActive ? const Color(0xFF2563EB) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive
                          ? const Color(0xFF2563EB)
                          : (isCompleted ? const Color(0xFF0F172A) : Colors.grey))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: isCompleted ? const Color(0xFF475569) : Colors.grey)),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Text(time,
            style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF2563EB) : const Color(0xFF475569))),
      ],
    );
  }
}
