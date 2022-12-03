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
      child: MultiBlocListener(
        listeners: [
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (p, c) =>
                p.isLocationPermissionGrantedAndServiceEnabled !=
                    c.isLocationPermissionGrantedAndServiceEnabled &&
                c.isLocationPermissionGrantedAndServiceEnabled,
            listener: (context, state) {
              Navigator.pop(context);
            },
          ),
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (p, c) =>
                p.displayOpenAppSettingsDialog !=
                    c.displayOpenAppSettingsDialog &&
                c.displayOpenAppSettingsDialog,
            listener: (context, state) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: AppSettingsDialog(cancelDialog: () {
                      context.read<PermissionCubit>().hidOpenAppSettingsDialog();
                    }, openAppSettings: () {
                      context.read<PermissionCubit>().openAppSettings();
                    }),
                  );
                },
              );
            },
          ),
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (p, c) =>
                p.displayOpenAppSettingsDialog !=
                    c.displayOpenAppSettingsDialog &&
                !c.displayOpenAppSettingsDialog,
            listener: (context, state) {
              Navigator.pop(context);
            },
          ),
        ],
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
                      // context.read<PermissionCubit>().requestLocationPermission();
                      showDialog(
                        context: context,
                        builder: (context) {
                          final bool isLocationPermissionGranted =
                              context.select((PermissionCubit element) =>
                                  element.state.isLocationPermissionGranted);
                          // to get the new data right away.
                          final bool isLocationServicesEnabled = context.select(
                              (PermissionCubit element) =>
                                  element.state.isLocationServicesEnabled);
                          return AlertDialog(
                            content: PermissionDialog(
                                isLocationPermissionGranted:
                                    isLocationPermissionGranted,
                                isLocationServicesEnabled:
                                    isLocationServicesEnabled),
                          );
                        },
                      );
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
                // const PermissionDialog()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionDialog extends StatelessWidget {
  final bool isLocationServicesEnabled;
  final bool isLocationPermissionGranted;

  const PermissionDialog(
      {Key? key,
      required this.isLocationServicesEnabled,
      required this.isLocationPermissionGranted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
              "Please allow location and services to view our location."),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Location Permission"),
              TextButton(
                  onPressed: isLocationPermissionGranted
                      ? null
                      : () {
                          context
                              .read<PermissionCubit>()
                              .requestLocationPermission();
                        },
                  child:
                      Text(isLocationPermissionGranted ? "allowed" : "allow")),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Location Services"),
              TextButton(
                  onPressed: isLocationServicesEnabled
                      ? null
                      : () {
                          context
                              .read<PermissionCubit>()
                              .openLocationSettings();
                        },
                  child: Text(isLocationServicesEnabled ? "allowed" : "allow")),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class AppSettingsDialog extends StatelessWidget {
  final Function openAppSettings;
  final Function cancelDialog;

  const AppSettingsDialog(
      {Key? key, required this.openAppSettings, required this.cancelDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
              "You need to open app settings to grand the location permission"),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => openAppSettings(),
                  child: const Text("Open App Settings")),
              TextButton(
                  onPressed: () => cancelDialog(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
