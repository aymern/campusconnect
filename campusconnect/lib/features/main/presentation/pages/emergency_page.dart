import 'package:flutter/material.dart';

import '../../../location/presentation/pages/location_home_page.dart';

/// Emergency feature page.
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Emergency', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.call_rounded, color: Colors.red),
              title: Text('Emergency contacts'),
              subtitle: Text('Campus security • 911 • Counseling center'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LocationHomePage()),
              );
            },
            icon: const Icon(Icons.sos_rounded),
            label: const Text('Open campus map'),
          ),
        ],
      ),
    );
  }
}
