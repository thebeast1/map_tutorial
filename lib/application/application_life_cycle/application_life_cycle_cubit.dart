import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'application_life_cycle_state.dart';

class ApplicationLifeCycleCubit extends Cubit<ApplicationLifeCycleState>
    with WidgetsBindingObserver {
  ApplicationLifeCycleCubit() : super(ApplicationLifeCycleState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    emit(state.copyWith(appLifecycleState: appLifecycleState));
  }
}
