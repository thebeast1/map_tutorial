import 'package:injectable/injectable.dart';
import 'package:map_tutorial/domain/permission/i_permission_service.dart';
import 'package:map_tutorial/domain/permission/location_permission_status.dart';
import 'package:geolocator/geolocator.dart';

@LazySingleton(as: IPermissionService)
class PermissionService implements IPermissionService {
  @override
  Future<bool> isLocationPermissionGranted() async {
    final status = await Geolocator.checkPermission();
    final isGranted = status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
    return isGranted;
  }

  @override
  Future<bool> isLocationServicesEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Stream<bool> get locationServicesStatusStream =>
      Geolocator.getServiceStatusStream()
          .map((serviceStatus) => serviceStatus == ServiceStatus.enabled);

  @override
  Future<LocationPermissionStatus> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    LocationPermissionStatus result = LocationPermissionStatus.granted;
    if (status == LocationPermission.deniedForever) {
      result = LocationPermissionStatus.deniedForever;
    } else if (status == LocationPermission.denied ||
        status == LocationPermission.unableToDetermine) {
      result = LocationPermissionStatus.denied;
    }
    return result;
  }
}
