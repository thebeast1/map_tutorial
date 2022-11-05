import 'package:get_it/get_it.dart';
import 'package:map_tutorial/application/application_life_cycle/application_life_cycle_cubit.dart';
import 'package:map_tutorial/application/permission/permission_cubit.dart';
import 'package:map_tutorial/domain/permission/i_permission_service.dart';
import 'package:map_tutorial/infrastructure/permission/permission_service.dart';

final getIt = GetIt.instance;

initialize() {
  getIt.registerLazySingleton<IPermissionService>(() => PermissionService());

  getIt.registerLazySingleton<ApplicationLifeCycleCubit>(
      () => ApplicationLifeCycleCubit());

  getIt.registerLazySingleton<PermissionCubit>(
      () => PermissionCubit(getIt(), getIt()));
}
