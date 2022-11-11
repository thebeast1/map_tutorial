import 'package:map_tutorial/domain/location/i_location_service.dart';
import 'package:map_tutorial/domain/location/location_model.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorLocationService implements ILocationService {
  @override
  Stream<LocationModel> get positionStream => Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      )).map((position) => LocationModel(
          latitude: position.altitude, longitude: position.longitude));
}
