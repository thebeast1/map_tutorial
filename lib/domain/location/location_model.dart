class LocationModel {
  final double latitude, longitude;

  LocationModel({required this.latitude, required this.longitude});

  LocationModel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory LocationModel.empty() => LocationModel(longitude: 0, latitude: 0);
}
