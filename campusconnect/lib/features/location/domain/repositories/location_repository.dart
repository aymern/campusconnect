import '../entities/campus_building.dart';

abstract class LocationRepository {
  Future<List<CampusBuilding>> getCampusBuildings();
  Future<Map<String, dynamic>> getCurrentLocation();
}
