import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';
import 'package:test_ble/presentation/widgets/characteristic_tile.dart';
import 'package:test_ble/presentation/widgets/descriptor_tile.dart';
import 'package:test_ble/presentation/widgets/service_tile.dart';

class DeviceScreen extends StatefulWidget {
  final BT_Device device;

  const DeviceScreen({super.key, required this.device});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  BT_Device get _device => widget.device;
  Iterable<BT_Service> get _services => _device.services;
  int get _rssi => _device.rssi;
  int get _mtuSize => _device.mtu;

  late StreamSubscription<BT_Device> _connectionStateSubscription;
  late StreamSubscription<BT_Device> _mtuSubscription;
  late StreamSubscription<BT_Device> _onNewServicesDiscoveredSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = _device.onConnectionStateChange((device) async {
      setState(() {});
    });

    _mtuSubscription = _device.onMtuChange((device) {
      setState(() {});
    });

    _onNewServicesDiscoveredSubscription = _device.onDiscoveryStateChange((device) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _onNewServicesDiscoveredSubscription.cancel();
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
    try {
      await _device.discover();
      MessageSnackBar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    }
    setState(() {});
  }

  Future onRequestMtuPressed() async {
    try {
      await widget.device.requestMtu(20);
      MessageSnackBar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Change Mtu Error:", e), success: false);
    }
  }

  List<Widget> _buildServiceTiles(BuildContext context, BT_Device d) {
    return _services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
      ),
    )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BT_Characteristic c) {
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
        Text(((isConnected) ? '$_rssi dBm' : ''), style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      // index: (_isDiscoveringServices) ? 1 : 0,
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
    return TextButton(
      onPressed: isConnected ? onDisconnectPressed : onConnectPressed,
      child: Text(
        isConnected ? "DISCONNECT" : "CONNECT",
        style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: MessageSnackBar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
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
