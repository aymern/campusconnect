import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/campus_building.dart';
import '../../domain/repositories/location_repository.dart';

class GeolocatorLocationRepository implements LocationRepository {
  @override
  Future<List<CampusBuilding>> getCampusBuildings() async {
    return [
      const CampusBuilding(
        id: 'library',
        name: 'North Library',
        description: 'Study hub',
        latitude: 33.4484,
        longitude: -112.0740,
        category: 'Academic',
      ),
      const CampusBuilding(
        id: 'student-center',
        name: 'Student Center',
        description: 'Campus services',
        latitude: 33.4498,
        longitude: -112.0722,
        category: 'Student Services',
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> getCurrentLocation() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      return {'latitude': 33.4484, 'longitude': -112.0740, 'status': 'permission_denied'};
    }

    final position = await Geolocator.getCurrentPosition();
    final placemark = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final place = placemark.isNotEmpty ? placemark.first : null;
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'status': 'ok',
      'address': place?.name ?? 'Current location',
    };
  }
}
