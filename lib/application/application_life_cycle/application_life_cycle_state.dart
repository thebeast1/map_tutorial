part of 'application_life_cycle_cubit.dart';

class ApplicationLifeCycleState {
  AppLifecycleState appLifecycleState;

  ApplicationLifeCycleState(
      {this.appLifecycleState = AppLifecycleState.resumed});

  ApplicationLifeCycleState copyWith({
    AppLifecycleState? appLifecycleState,
  }) {
    return ApplicationLifeCycleState(
      appLifecycleState: appLifecycleState ?? this.appLifecycleState,
    );
  }

  bool get isResumed => appLifecycleState == AppLifecycleState.resumed;
}
