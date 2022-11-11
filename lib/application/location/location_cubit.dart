import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial/application/permission/permission_cubit.dart';
import 'package:map_tutorial/domain/location/i_location_service.dart';
import 'package:map_tutorial/domain/location/location_model.dart';
import 'package:rxdart/rxdart.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationService _locationService;
  final PermissionCubit _permissionCubit;

  StreamSubscription<LocationModel>? _userPositionSubscription;

  StreamSubscription<List<PermissionState>>? _permissionStateSubscription;

  LocationCubit(this._locationService, this._permissionCubit)
      : super(LocationState.initial()) {
    if (_permissionCubit.state.isLocationPermissionGrantedAndServiceEnabled) {
      _userPositionSubscription =
          _locationService.positionStream.listen(_userPositionListener);
    }
    _permissionStateSubscription = _permissionCubit.stream
        .startWith(_permissionCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;
      if (previous.isLocationPermissionGrantedAndServiceEnabled !=
              current.isLocationPermissionGrantedAndServiceEnabled &&
          current.isLocationPermissionGrantedAndServiceEnabled) {
        await _userPositionSubscription?.cancel();

        _userPositionSubscription =
            _locationService.positionStream.listen(_userPositionListener);
      } else if (previous.isLocationPermissionGrantedAndServiceEnabled !=
              current.isLocationPermissionGrantedAndServiceEnabled &&
          !current.isLocationPermissionGrantedAndServiceEnabled) {
        _userPositionSubscription?.cancel();
      }
    });
  }

  void _userPositionListener(LocationModel location) {
    emit(state.copyWith(userLocation: location));
  }

  @override
  Future<void> close() async {
    await _userPositionSubscription?.cancel();
    await _permissionStateSubscription?.cancel();
    super.close();
  }
}
