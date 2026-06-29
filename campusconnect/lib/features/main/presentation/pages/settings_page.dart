import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_provider.dart';

/// Settings feature page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: Text(themeProvider.isDarkModeEnforced
                ? 'Locked by the campus dark-mode rule.'
                : 'Toggle theme manually.'),
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.isDarkModeEnforced
                ? null
                : (value) => themeProvider.setTheme(value ? ThemeMode.dark : ThemeMode.light),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Campus code'),
            subtitle: Text(themeProvider.themeStatusLabel),
          ),
        ],
      ),
    );
  }
}
