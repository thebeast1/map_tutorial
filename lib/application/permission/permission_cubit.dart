import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial/application/application_life_cycle/application_life_cycle_cubit.dart';
import 'package:map_tutorial/domain/permission/i_permission_servic.dart';
import 'package:map_tutorial/domain/permission/location_permission_status.dart';
import 'package:rxdart/rxdart.dart';

part 'permission_state.dart';

@lazySingleton
class PermissionCubit extends Cubit<PermissionState> {
  final IPermissionService _permissionService;
  StreamSubscription<bool>? _locationStatusSubscription;
  final ApplicationLifeCycleCubit _applicationLifeCycleCubit;
  StreamSubscription<Iterable<ApplicationLifeCycleState>>?
      _appLifeCycleSubscription;

  PermissionCubit(this._permissionService, this._applicationLifeCycleCubit)
      : super(PermissionState()) {
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

    _appLifeCycleSubscription = _applicationLifeCycleCubit.stream
        .startWith(_applicationLifeCycleCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;
      log("Previous app life cycle stateus is: ${previous.appLifecycleState.name} -- ${previous.isResumed}");
      log("current app life cycle stateus is: ${current.appLifecycleState.name} -- ${current.isResumed}");

      // if the user was not in the foreground and now comes to the foreground.
      if (previous.isResumed != current.isResumed && current.isResumed) {
        bool isGranted = await _permissionService.isLocationPermissionGranted();
        if (state.isLocationPermissionGranted != isGranted && isGranted) {
          hidOpenAppSettingsDialog();
        }
        emit(state.copyWith(isLocationPermissionGranted: isGranted));
      }
    });
  }

  @override
  Future<void> close() async {
    await _locationStatusSubscription?.cancel();
    await _appLifeCycleSubscription?.cancel();
    super.close();
  }

  void requestLocationPermission() async {
    final status = await _permissionService.requestLocationPermission();
    final bool displayOpenAppSettingsDialog =
        status == LocationPermissionStatus.deniedForever;
    final bool isGranted = status == LocationPermissionStatus.granted;
    emit(state.copyWith(
        isLocationPermissionGranted: isGranted,
        displayOpenAppSettingsDialog: displayOpenAppSettingsDialog));
  }

  Future<void> openAppSettings() async {
    await _permissionService.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await _permissionService.openLocationSettings();
  }

  void hidOpenAppSettingsDialog() {
    emit(state.copyWith(displayOpenAppSettingsDialog: false));
  }
}
