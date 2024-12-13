import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';

abstract class BluetoothScannerTile<BluetoothScannerDeviceTileController> extends StatefulWidget {
  const BluetoothScannerTile({
    super.key,
    required BluetoothScannerDeviceTileController device,
  }) : _device = device;

  final BluetoothScannerDeviceTileController _device;
}

abstract class BluetoothScannerTileState<Tile extends BluetoothScannerTile> extends State<Tile> with WidgetsBindingObserver {
  late final BluetoothScannerDeviceTileBloc bloc;

  BluetoothScannerDeviceTileController get device => widget._device;
  BlocBuilder<BluetoothScannerDeviceTileBloc, BluetoothScannerDeviceTileState> builder(BuildContext context, BluetoothScannerDeviceTileBloc bloc);

  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentLocale = View.of(context).platformDispatcher.locale;
    bloc = BluetoothScannerDeviceTileBloc(
      device: device,
    );
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales != null && locales.isNotEmpty) {
      final newLocale = locales.first;
      if (_currentLocale != newLocale) {
        setState(() {
          _currentLocale = newLocale;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: builder(context, bloc),
    );
  }
}