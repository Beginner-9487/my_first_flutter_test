import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_event.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_state.dart';

class BackgroundWorkBloc extends Bloc<BackgroundWorkEvent, BackgroundWorkState> {

  BackgroundProcessor backgroundProcessor;

  bool get isRunning => backgroundProcessor.isRunning;

  late StreamSubscription<bool> _onRunningStateChange;

  BackgroundWorkBloc(this.backgroundProcessor) : super(initialState) {
    on<BackgroundWorkStart>((event, emit) async {
      await backgroundProcessor.startBackgroundProcess();
      _refreshUI();
    });
    on<BackgroundWorkStop>((event, emit) async {
      await backgroundProcessor.stopBackgroundProcess();
      _refreshUI();
    });
    on<BackgroundWorkUpdate>((event, emit) {
      _refreshUI();
    });
    on<BackgroundWorkDispose>((event, emit) {
      emit(BackgroundWorkDisposeState());
    });

    _onRunningStateChange = backgroundProcessor.onRunningStateChange((state) {
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
