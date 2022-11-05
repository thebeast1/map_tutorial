import 'package:map_tutorial/domain/permission/location_permission_status.dart';

abstract class IPermissionService {
  // If the user granted location permission at a time of the app.
  Future<bool> isLocationPermissionGranted();

  // The changes in location permission state in background.
  // If the user enabled location service at a time from the nav bar.
  Future<bool> isLocationServicesEnabled();

  //The change in location service status form the nav bar.
  Stream<bool> get locationServicesStatusStream;

  //Request location permission dialog.
  Future<LocationPermissionStatus> requestLocationPermission();
}
