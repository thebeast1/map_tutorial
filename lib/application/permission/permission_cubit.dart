import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial/domain/permission/i_permission_service.dart';
import 'package:map_tutorial/domain/permission/location_permission_status.dart';

part 'permission_state.dart';

@lazySingleton
class PermissionCubit extends Cubit<PermissionState> {
  final IPermissionService _permissionService;
  StreamSubscription<bool>? _locationStatusSubscription;

  PermissionCubit(this._permissionService) : super(PermissionState()) {
    _permissionService.isLocationPermissionGranted().then(
      (bool isLocationPermissionGranted) {
        emit(state.copyWith(
            isLocationPermissionGranted: isLocationPermissionGranted));
      },
    );

    _permissionService
        .isLocationServicesEnabled()
        .then((bool isLocationServicesEnabled) {
      emit(
          state.copyWith(isLocationServicesEnabled: isLocationServicesEnabled));
    });

    _locationStatusSubscription = _permissionService
        .locationServicesStatusStream
        .listen((isLocationServicesEnabled) {
      emit(
          state.copyWith(isLocationServicesEnabled: isLocationServicesEnabled));
    });
  }

  @override
  Future<void> close() async {
    await _locationStatusSubscription?.cancel();
    super.close();
  }

  void requestLocationPermission() async {
    final status = await _permissionService.requestLocationPermission();
    final bool isGranted = status == LocationPermissionStatus.granted;
    emit(state.copyWith(isLocationPermissionGranted: isGranted));
  }
}
