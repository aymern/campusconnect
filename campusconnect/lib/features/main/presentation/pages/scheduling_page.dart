import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../scheduling/presentation/providers/scheduling_provider.dart';

/// Smart scheduling feature page.
class SchedulingPage extends StatelessWidget {
  const SchedulingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchedulingProvider>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Smart scheduling', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: const Text('Today'),
            subtitle: Text('${provider.entries.length} planned item${provider.entries.length == 1 ? '' : 's'}'),
          ),
        ),
        const SizedBox(height: 8),
        ...provider.entries.map((entry) => Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: Text(entry.title),
                subtitle: Text('${entry.start.toLocal().toString().substring(0, 16)} · ${entry.location}'),
              ),
            )),
      ],
    );
  }
}
