part of 'location_cubit.dart';

class LocationState {
  final LocationModel userLocation;

  LocationState({required this.userLocation});

  factory LocationState.initial() =>
      LocationState(userLocation: LocationModel.empty());

  LocationState copyWith({
    LocationModel? userLocation,
  }) {
    return LocationState(
      userLocation: userLocation ?? this.userLocation,
    );
  }
}
