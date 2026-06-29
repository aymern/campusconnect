import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_provider.dart';

/// Profile feature page.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
              title: Text(authProvider.user?.email ?? 'Guest user'),
              subtitle: const Text('Student account'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: authProvider.signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
