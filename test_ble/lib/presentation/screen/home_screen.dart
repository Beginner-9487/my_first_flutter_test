import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_bloc.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_event.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_state.dart';
import 'package:test_ble/presentation/view/ble_scanning_view.dart';
import 'package:test_ble/presentation/view/bluetooth_off_screen.dart';
import 'package:test_ble/resources/ble_global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState<Screen extends StatefulWidget> extends State<Screen> with TickerProviderStateMixin {
  BLERepositoryBloc bleRepositoryBloc = BLERepositoryBloc(
    BLEGlobal.instance.bleRepository,
  );

  bool get isBluetoothOn => bleRepositoryBloc.isBluetoothOn;

  late AppBar backgroundWorkHeader;

  late final Widget fullScreen;

  @override
  void initState() {
    super.initState();
    fullScreen = BlocProvider(
      create: (context) => bleRepositoryBloc,
      child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
          bloc: bleRepositoryBloc,
          builder: (context, state) {
            return (isBluetoothOn) ?
            BLEScanningView(
                bleRepositoryBloc: bleRepositoryBloc,
            ) :
            const BluetoothOffView();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return fullScreen;
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    bleRepositoryBloc.add(BLEDispose());
  }
}
