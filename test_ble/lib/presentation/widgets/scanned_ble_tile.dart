import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:test_ble/presentation/bloc/device/ble_device_bloc.dart';
import 'package:test_ble/presentation/bloc/device/ble_device_event.dart';
import 'package:test_ble/presentation/bloc/device/ble_device_state.dart';
import 'package:test_ble/presentation/screen/device_screen.dart';
import 'package:test_ble/resources/app_theme.dart';

class ScannedBLETile extends StatefulWidget {
  ScannedBLETile({
    super.key,
    required this.bleDeviceBloc,
  });

  BLEDeviceBloc bleDeviceBloc;

  @override
  State<ScannedBLETile> createState() => _ScannedBLETileState();
}

class _ScannedBLETileState extends State<ScannedBLETile> {

  _ScannedBLETileState();
  BLEDevice get device => bluetoothDvBloc.device;
  BLEDeviceBloc get bluetoothDvBloc => widget.bleDeviceBloc;

  bool get isConnected => bluetoothDvBloc.isConnected;
  bool get connectable => bluetoothDvBloc.connectable;

  late TextEditingController _labelNameController;

  VoidCallback? get onConnect =>
      (connectable) ?
          () {bluetoothDvBloc.add(BLEDeviceConnect());}
          : null;
  VoidCallback? get onDisconnect =>
      (connectable) ?
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeviceScreen(
                device: device,
              )),
            );
          }
          : null;

  @override
  void initState() {
    super.initState();
    _labelNameController = TextEditingController(text: device.name);
  }

  @override
  void dispose() {
    bluetoothDvBloc.add(BLEDeviceEventDispose());
    super.dispose();
  }

  Widget _buildTitle(BuildContext context) {
    if (device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            device.address,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return Text(device.address.toString());
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (isConnected) ? onDisconnect : onConnect,
      child: isConnected ? const Text("OPEN") : const Text("CONNECT"),
    );
  }

  Widget connectedTile(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.bleConnectedColor,
      title: _buildTitle(context),
      leading: Text(device.rssi.toString()),
      trailing: _buildConnectButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  Widget disconnectedTile(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.bleDisconnectedColor,
      title: _buildTitle(context),
      leading: Text(device.rssi.toString()),
      trailing: _buildConnectButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BLEDeviceBloc, BLEDeviceState>(
        bloc: bluetoothDvBloc,
        builder: (context, blueState) {
          return isConnected ? connectedTile(context) : disconnectedTile(context);
        }
    );
  }
}