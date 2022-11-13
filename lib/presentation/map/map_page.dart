import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial/application/location/location_cubit.dart';
import 'package:map_tutorial/application/permission/permission_cubit.dart';
import 'package:map_tutorial/domain/location/location_model.dart';
import 'package:map_tutorial/injection.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Map Tutorial"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocSelector<PermissionCubit, PermissionState, bool>(
                selector: (state) => state.isLocationPermissionGranted,
                builder: (context, state) => Text(
                    "Location Permission : ${state ? 'enabled' : 'disabled'}"),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocSelector<PermissionCubit, PermissionState, bool>(
                selector: (state) => state.isLocationServicesEnabled,
                builder: (context, state) {
                  return Text(
                      "Location Services : ${state ? 'enabled' : 'disabled'}");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    debugPrint("Location services Button Pressed!");
                    context.read<PermissionCubit>().requestLocationPermission();
                  },
                  child: const Text("Request Location Permission")),
              const SizedBox(
                height: 20,
              ),
              BlocSelector<LocationCubit, LocationState, LocationModel>(
                selector: (state) {
                  return state.userLocation;
                },
                builder: (context, userLocation) {
                  return Text(
                      "Latitude:${userLocation.latitude} Longitude: ${userLocation.longitude}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
