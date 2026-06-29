import 'package:flutter/material.dart';

/// Domain model for each destination in the main application navigation shell.
class AppNavItem {
  const AppNavItem({
    required this.routeName,
    required this.label,
    required this.icon,
    required this.description,
  });

  final String routeName;
  final String label;
  final IconData icon;
  final String description;
}
