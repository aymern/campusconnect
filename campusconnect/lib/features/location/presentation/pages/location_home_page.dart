import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import 'campus_map_page.dart';

class LocationHomePage extends StatelessWidget {
  const LocationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: const CampusMapPage(),
    );
  }
}
