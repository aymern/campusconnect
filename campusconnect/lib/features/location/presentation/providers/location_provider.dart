import 'package:flutter/foundation.dart';

import '../../data/repositories/geolocator_location_repository.dart';
import '../../domain/entities/campus_building.dart';
import '../../domain/repositories/location_repository.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider({LocationRepository? repository})
      : _repository = repository ?? GeolocatorLocationRepository();

  final LocationRepository _repository;
  List<CampusBuilding> _buildings = const [];
  Map<String, dynamic> _currentLocation = const {};
  bool _isLoading = false;
  String _status = 'idle';

  List<CampusBuilding> get buildings => List.unmodifiable(_buildings);
  Map<String, dynamic> get currentLocation => Map.unmodifiable(_currentLocation);
  bool get isLoading => _isLoading;
  String get status => _status;

  Future<void> loadCampusData() async {
    _isLoading = true;
    _status = 'loading';
    notifyListeners();

    _buildings = await _repository.getCampusBuildings();
    _currentLocation = await _repository.getCurrentLocation();
    _status = (_currentLocation['status'] as String?) ?? 'ready';

    _isLoading = false;
    notifyListeners();
  }
}
