import 'package:map_tutorial/domain/location/location_model.dart';

abstract class ILocationService {
  Stream<LocationModel> get positionStream;
}
