import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../location/presentation/pages/location_home_page.dart';
import '../providers/emergency_provider.dart';

class EmergencyAlertPage extends StatefulWidget {
  const EmergencyAlertPage({super.key});

  @override
  State<EmergencyAlertPage> createState() => _EmergencyAlertPageState();
}

class _EmergencyAlertPageState extends State<EmergencyAlertPage> {
  int _countdown = 20;
  bool _counting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<EmergencyProvider>();
      await provider.initialize();
    });
  }

  Future<void> _startCountdown(EmergencyProvider provider) async {
    _counting = true;
    _countdown = 20;
    setState(() {});

    while (_countdown > 0 && _counting) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown--);
    }

    if (_counting) {
      await provider.sendEmergencyAlert(type: 'Emergency', message: 'Panic alert initiated.');
      _counting = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmergencyProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency')), 
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                title: const Text('Emergency contacts'),
                subtitle: const Text('Campus security • 911 • Counseling center'),
              ),
            ),
            const SizedBox(height: 16),
            if (_counting)
              Text('Sending in $_countdown seconds', style: Theme.of(context).textTheme.titleLarge)
            else if (provider.hasActiveAlert)
              const Text('Alert sent')
            else
              const Text('Ready'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: provider.isSending || _counting
                  ? null
                  : () async {
                      await _startCountdown(provider);
                    },
              icon: const Icon(Icons.sos_rounded),
              label: const Text('Panic button'),
            ),
            if (_counting)
              TextButton(
                onPressed: () {
                  _counting = false;
                  setState(() {});
                },
                child: const Text('Cancel alert'),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LocationHomePage()),
                );
              },
              icon: const Icon(Icons.map_rounded),
              label: const Text('Open campus map'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: provider.alertHistory.map((alert) {
                  return ListTile(
                    title: Text(alert['address'] ?? 'Unknown location'),
                    subtitle: Text('${alert['type']} · ${alert['status']}'),
                    trailing: Text(alert['created_at'] != null ? DateTime.parse(alert['created_at'] as String).toLocal().toString().substring(11,16) : ''),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
