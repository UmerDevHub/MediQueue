import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveQueueManagementScreen extends StatefulWidget {
  const LiveQueueManagementScreen({Key? key}) : super(key: key);

  @override
  State<LiveQueueManagementScreen> createState() => _LiveQueueManagementScreenState();
}

class _LiveQueueManagementScreenState extends State<LiveQueueManagementScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _queueEntries = [];
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchQueue();
    _listenToQueueChanges();
  }

  @override
  void dispose() {
    if (_channel != null) _supabase.removeChannel(_channel!);
    super.dispose();
  }

  Future<void> _fetchQueue() async {
    try {
      final res = await _supabase
          .from('queue')
          .select('*, users(full_name), hospitals(name)')
          .inFilter('status', ['incoming', 'en_route', 'arrived'])
          .order('queue_position');
      if (mounted) setState(() { _queueEntries = res; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _listenToQueueChanges() {
    _channel = _supabase
        .channel('ha-queue-management')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'queue',
          callback: (_) => _fetchQueue(),
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.go('/admin_home'),
        ),
        title: const Text('MediQueue',
            style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFF10B981), size: 12),
                    SizedBox(width: 8),
                    Text('User Queue',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: const Row(
                    children: [
                      Icon(Icons.sort, size: 16, color: Color(0xFF475569)),
                      SizedBox(width: 4),
                      Text('PRIORITY',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _queueEntries.isEmpty
                    ? const Center(child: Text('No active queue entries.', style: TextStyle(color: Color(0xFF475569))))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _queueEntries.length,
                        itemBuilder: (ctx, i) {
                          final e = _queueEntries[i];
                          final userName = (e['users'] as Map?)?['full_name'] ?? 'Unknown User';
                          final status = e['status'] ?? 'incoming';
                          final pos = e['queue_position']?.toString() ?? '—';
                          final severity = (e['severity_score'] ?? 5) > 7 ? 'CRITICAL' : 'MODERATE';
                          return _buildQueueCard(
                            initials: userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                            name: userName,
                            details: 'Position #$pos in queue',
                            severity: severity,
                            status: status.toUpperCase().replaceAll('_', ' '),
                            time: '',
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchQueue,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildQueueCard({
    required String initials,
    required String name,
    required String details,
    required String severity,
    required String status,
    required String time,
  }) {
    final isCritical = severity == 'CRITICAL';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isCritical ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
            child: Text(initials,
                style: TextStyle(
                    color: isCritical ? const Color(0xFFDC2626) : const Color(0xFF1D4ED8),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    if (time.isNotEmpty)
                      Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(color: Color(0xFF475569))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCritical ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(severity,
                          style: TextStyle(
                              color: isCritical
                                  ? const Color(0xFF991B1B)
                                  : const Color(0xFF1E3A8A),
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(status,
                          style: const TextStyle(
                              color: Color(0xFF3730A3), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
