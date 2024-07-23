import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';
import 'package:test_ble/presentation/widgets/characteristic_tile.dart';
import 'package:test_ble/presentation/widgets/descriptor_tile.dart';
import 'package:test_ble/presentation/widgets/service_tile.dart';

class DeviceScreen extends StatefulWidget {
  final BLEDevice device;

  const DeviceScreen({super.key, required this.device});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  BLEDevice get _device => widget.device;
  Iterable<BLEService> get _services => _device.services;
  int get _rssi => _device.rssi;
  int get _mtuSize => _device.mtuSize;
  bool get _isDiscoveringServices => _device.isDiscoveringServices;
  bool get _isConnecting => _device.isConnecting;
  bool get _isDisconnecting => _device.isDisconnecting;

  late StreamSubscription<bool> _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  late StreamSubscription<Iterable<BLEService>> _onNewServicesDiscoveredSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = _device.onConnectStateChange((isConnected) async {
      setState(() {});
    });

    _mtuSubscription = _device.onMtuChange((mtu) {
      setState(() {});
    });

    _isConnectingSubscription = _device.onConnecting((isConnecting) {
      setState(() {});
    });

    _isDisconnectingSubscription = _device.onDisconnecting((isDisconnecting) {
      setState(() {});
    });

    _onNewServicesDiscoveredSubscription = _device.onNewServicesDiscovered((services) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    super.dispose();
  }

  bool get isConnected => _device.isConnected;

  Future onConnectPressed() async {
    try {
      await _device.connect();
      MessageSnackBar.show(ABC.c, "Connect: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Connect Error:", e), success: false);
    }
  }

  Future onCancelPressed() async {
    try {
      await _device.disconnect();
      MessageSnackBar.show(ABC.c, "Cancel: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await _device.disconnect();
      MessageSnackBar.show(ABC.c, "Disconnect: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Disconnect Error:", e), success: false);
    }
  }

  Future onDiscoverServicesPressed() async {
    setState(() {});
    try {
      _device.discoverServices();
      MessageSnackBar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    }
    setState(() {});
  }

  Future onRequestMtuPressed() async {
    try {
      await widget.device.readMtu();
      MessageSnackBar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Change Mtu Error:", e), success: false);
    }
  }

  List<Widget> _buildServiceTiles(BuildContext context, BLEDevice d) {
    return _services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
      ),
    )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BLECharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(widget.device.address),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected ? const Icon(Icons.bluetooth_connected) : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''), style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          onPressed: onDiscoverServicesPressed,
          child: const Text("Get Services"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        subtitle: Text('$_mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting ? onCancelPressed : (isConnected ? onDisconnectPressed : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: MessageSnackBar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.platformName),
          actions: [buildConnectButton(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
              ListTile(
                leading: buildRssiTile(context),
                title: Text('Device is Connected: $isConnected.'),
                trailing: buildGetServices(context),
              ),
              buildMtuTile(context),
              ..._buildServiceTiles(context, _device),
            ],
          ),
        ),
      ),
    );
  }
}
