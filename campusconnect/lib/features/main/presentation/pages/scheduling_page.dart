import 'package:flutter/material.dart';

/// Smart scheduling feature page.
class SchedulingPage extends StatelessWidget {
  const SchedulingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Smart scheduling', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.schedule_rounded),
            title: Text('Today'),
            subtitle: Text('3 classes · 2 study blocks planned'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.calendar_month_rounded),
            title: Text('This week'),
            subtitle: Text('Review sessions and campus events'),
          ),
        ),
      ],
    );
  }
}
