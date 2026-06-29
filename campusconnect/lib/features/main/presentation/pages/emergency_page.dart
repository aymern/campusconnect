import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../emergency/data/repositories/emergency_repository.dart';
import '../../../emergency/presentation/pages/emergency_alert_page.dart';
import '../../../emergency/presentation/providers/emergency_provider.dart';
import '../../../location/data/repositories/geolocator_location_repository.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

/// Emergency feature page.
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmergencyProvider>(
      create: (context) => EmergencyProvider(
        repository: SqliteEmergencyRepository(),
        locationRepository: GeolocatorLocationRepository(),
        notificationProvider: context.read<NotificationProvider>(),
        demoMode: kDebugMode,
      ),
      child: const EmergencyAlertPage(),
    );
  }
}
