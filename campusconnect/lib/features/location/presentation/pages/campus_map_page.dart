import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadCampusData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map')),
      body: Column(
        children: [
          if (locationProvider.isLoading)
            const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: locationProvider.buildings.length,
              itemBuilder: (context, index) {
                final building = locationProvider.buildings[index];
                return ListTile(
                  title: Text(building.name),
                  subtitle: Text(building.description),
                  trailing: Text(building.category),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              locationProvider.currentLocation.isEmpty
                  ? 'Location unavailable'
                  : 'Current location: ${locationProvider.currentLocation['address']} (${locationProvider.currentLocation['status']})',
            ),
          ),
        ],
      ),
    );
  }
}
