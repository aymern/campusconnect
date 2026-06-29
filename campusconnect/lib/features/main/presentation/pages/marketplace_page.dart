import 'package:flutter/material.dart';

/// Marketplace feature page.
class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Marketplace', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.shopping_bag_rounded),
            title: Text('Textbook bundle'),
            subtitle: Text('Chemistry 101 · \$35'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.electric_bike_rounded),
            title: Text('Bike for sale'),
            subtitle: Text('Great condition · \$90'),
          ),
        ),
      ],
    );
  }
}
