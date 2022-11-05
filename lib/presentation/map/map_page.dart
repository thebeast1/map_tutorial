import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial/application/permission/permission_cubit.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: const Text("Request Location Permission"))
          ],
        ),
      ),
    );
  }
}
