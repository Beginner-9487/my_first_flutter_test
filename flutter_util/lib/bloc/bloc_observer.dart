import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class GlobalBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if (kDebugMode) {
      debugPrint('Bloc-onCreate : $bloc');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      debugPrint('Bloc-onEvent : $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Object? change) {
    if (kDebugMode) {
      debugPrint('Bloc-onChange : $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      debugPrint('Bloc-onTransition : $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Bloc-onError : $error');
      debugPrint('Bloc-onError-stackTrace : $stackTrace');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) {
      debugPrint('Bloc-onClose : $bloc');
    }
  }
}