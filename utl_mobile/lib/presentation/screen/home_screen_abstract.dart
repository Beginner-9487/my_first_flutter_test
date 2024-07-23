import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_bloc.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_state.dart';
import 'package:utl_mobile/presentation/header/background_work_header.dart';
import 'package:utl_mobile/presentation/view/bluetooth_off_screen.dart';
import 'package:flutter_r/r.dart';

abstract class HomeScreenState<Screen extends StatefulWidget> extends State<Screen> with TickerProviderStateMixin {
  late BackgroundWorkBloc backgroundWorkBloc;
  late BLERepositoryBloc bleRepositoryBloc;

  BackgroundProcessor get backgroundProcessor;
  BLERepository get bleRepository;

  bool get isBluetoothOn => bleRepositoryBloc.isBluetoothOn;

  late AppBar backgroundWorkHeader;

  late final Widget fullScreen;
  Widget get screen;

  @override
  void initState() {
    super.initState();
    backgroundWorkBloc = BackgroundWorkBloc(
      backgroundProcessor,
    );
    bleRepositoryBloc = BLERepositoryBloc(
      bleRepository,
    );
    backgroundWorkHeader = BackgroundWorkHeader(
      backgroundWorkBloc: backgroundWorkBloc,
      backgroundProcessor: backgroundProcessor,
    );
    fullScreen = BlocProvider(
      create: (context) => bleRepositoryBloc,
      child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
          bloc: bleRepositoryBloc,
          builder: (context, state) {
            return (isBluetoothOn) ?
            screen :
            const BluetoothOffView();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    R.set(context);
    return Builder(
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: backgroundWorkHeader,
          body: fullScreen,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    backgroundWorkBloc.add(BackgroundWorkDispose());
    bleRepositoryBloc.add(BLEDispose());
  }
}
