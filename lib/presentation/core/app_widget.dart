import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial/application/application_life_cycle/application_life_cycle_cubit.dart';
import 'package:map_tutorial/application/permission/permission_cubit.dart';
import 'package:map_tutorial/injection.dart';
import 'package:map_tutorial/presentation/map/map_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PermissionCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<ApplicationLifeCycleCubit>(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapPage(),
      ),
    );
  }
}
