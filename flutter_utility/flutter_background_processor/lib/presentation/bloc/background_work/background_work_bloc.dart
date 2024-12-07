import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_background_processor/presentation/bloc/background_work/background_work_event.dart';
import 'package:flutter_background_processor/presentation/bloc/background_work/background_work_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackgroundWorkBloc extends Bloc<BackgroundWorkEvent, BackgroundWorkState> {

  BackgroundProcessor backgroundWorkService;

  bool get isRunning => backgroundWorkService.isRunning;

  late StreamSubscription<bool> _onRunningStateChange;

  BackgroundWorkBloc(this.backgroundWorkService) : super(initialState) {
    on<BackgroundWorkStart>((event, emit) async {
      await backgroundWorkService.startBackgroundProcess();
      _refreshUI();
    });
    on<BackgroundWorkStop>((event, emit) async {
      await backgroundWorkService.stopBackgroundProcess();
      _refreshUI();
    });
    on<BackgroundWorkUpdate>((event, emit) {
      _refreshUI();
    });
    on<BackgroundWorkDispose>((event, emit) {
      emit(BackgroundWorkDisposeState());
    });

    _onRunningStateChange = backgroundWorkService.onRunningStateChange((state) {
      debugPrint("_onRunningStateChange: $state");
      _refreshUI();
    });
  }

  @override
  static BackgroundWorkState get initialState => BackgroundWorkNormalState();

  _refreshUI() {
    emit(BackgroundWorkNormalState());
  }
}
