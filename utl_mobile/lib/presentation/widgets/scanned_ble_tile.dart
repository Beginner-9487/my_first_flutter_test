import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_state.dart';

class ScannedBLETile extends StatefulWidget {
  ScannedBLETile({
    super.key,
    required this.bleDeviceBloc,
    this.onConnect,
    this.onDisconnect,
    this.colorConnected,
    this.colorDisconnected,
    this.textConnected = "",
    this.textDisconnected = "",
  });

  Color? colorConnected;
  Color? colorDisconnected;
  String textConnected;
  String textDisconnected;
  BLEDeviceBloc bleDeviceBloc;
  void Function(BLEDeviceBloc deviceBloc)? onConnect;
  void Function(BLEDeviceBloc deviceBloc)? onDisconnect;

  @override
  State<ScannedBLETile> createState() => _ScannedBLETileState();
}

class _ScannedBLETileState<Tile extends ScannedBLETile> extends State<Tile> {
  @override
  BLEDeviceBloc get bleDvBloc => widget.bleDeviceBloc;
  @override
  BLEDevice get device => bleDvBloc.device;

  @override
  Color? get colorConnected => widget.colorConnected;
  @override
  Color? get colorDisconnected => widget.colorDisconnected;
  @override
  String get textConnected => widget.textConnected;
  @override
  String get textDisconnected => widget.textDisconnected;

  @override
  bool get isConnected => bleDvBloc.isConnected;
  @override
  bool get connectable => bleDvBloc.connectable;

  @override
  VoidCallback? get onConnect {
    if(!connectable) {
      return null;
    }
    return (widget.onConnect == null)
        ? () {
          bleDvBloc.add(BLEDeviceConnect());
        }
        :() {
          widget.onConnect!(bleDvBloc);
        };
  }
  @override
  VoidCallback? get onDisconnect {
    if(!connectable) {
      return null;
    }
    return (widget.onDisconnect == null)
        ? () {
      bleDvBloc.add(BLEDeviceDisconnect());
    }
        :() {
      widget.onDisconnect!(bleDvBloc);
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bleDvBloc.add(BLEDeviceEventDispose());
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

  Widget _buildConnectionButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (isConnected) ? onDisconnect : onConnect,
      child: isConnected ? Text(textDisconnected) : Text(textConnected),
    );
  }

  @override
  Widget connectedTile(BuildContext context) {
    return ListTile(
      tileColor: widget.colorConnected,
      title: _buildTitle(context),
      leading: Text(device.rssi.toString()),
      trailing: _buildConnectionButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  Widget disconnectedTile(BuildContext context) {
    return ListTile(
      tileColor: colorDisconnected,
      title: _buildTitle(context),
      leading: Text(device.rssi.toString()),
      trailing: _buildConnectionButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BLEDeviceBloc, BLEDeviceState>(
        bloc: bleDvBloc,
        builder: (context, blueState) {
          return isConnected ? connectedTile(context) : disconnectedTile(context);
        }
    );
  }
}

class ScannedBLEExecuteTile extends ScannedBLETile {
  ScannedBLEExecuteTile({
    super.key,
    required super.bleDeviceBloc,
    super.onConnect,
    super.onDisconnect,
    super.colorConnected,
    super.colorDisconnected,
    super.textConnected,
    super.textDisconnected,
    this.onExecute,
  });

  VoidCallback? onExecute;

  @override
  State<ScannedBLEExecuteTile> createState() => _ScannedBLEExecuteTileState();
}

class _ScannedBLEExecuteTileState<Tile extends ScannedBLEExecuteTile> extends _ScannedBLETileState<Tile> {
  VoidCallback? get onExecute => (connectable) ? widget.onExecute : null;

  Widget _buildExecuteButton(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: onExecute,
      icon: const Icon(Icons.send),
    );
  }

  @override
  Widget connectedTile(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: widget.colorConnected,
      title: ListTile(
        title: ListTile(
          title: _buildTitle(context),
          trailing: _buildExecuteButton(context),
        ),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: [
        ListTile(
          leading: Text(device.rssi.toString()),
          title: _buildTitle(context),
          trailing: _buildConnectionButton(context),
        ),
      ],
    );
  }
}

class ScannedBLEExecuteTextTile extends ScannedBLETile {
  ScannedBLEExecuteTextTile({
    super.key,
    required super.bleDeviceBloc,
    super.onConnect,
    super.onDisconnect,
    super.colorConnected,
    super.colorDisconnected,
    super.textConnected,
    super.textDisconnected,
    this.onExecute,
    this.onTextChange,
    this.textDefault = "",
  });

  void Function(BLEDevice, String)? onExecute;
  void Function(BLEDevice, String)? onTextChange;
  String textDefault;

  @override
  State<ScannedBLEExecuteTextTile> createState() => _ScannedBLEExecuteTextTileState();
}

class _ScannedBLEExecuteTextTileState<Tile extends ScannedBLEExecuteTextTile> extends _ScannedBLETileState<Tile> {
  late TextEditingController _labelNameController;
  void Function(BLEDevice, String) get onTextChange => (widget.onTextChange != null) ? widget.onTextChange! : (BLEDevice device, String text) {};
  void Function(BLEDevice, String)? get onExecute => (connectable) ? widget.onExecute : null;

  @override
  void initState() {
    super.initState();
    _labelNameController = TextEditingController(text: widget.textDefault);
  }

  Widget _buildExecuteButton(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (onExecute != null) ?
      () {
        onExecute!(bleDvBloc.device, _labelNameController.value.text);
      } :
      null,
      icon: const Icon(Icons.send),
    );
  }

  @override
  Widget connectedTile(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: widget.colorConnected,
      title: ListTile(
        title: ListTile(
          title: TextField(
            controller: _labelNameController,
            onChanged: (String text) {
              onTextChange(bleDvBloc.device, text);
            },
          ),
          trailing: _buildExecuteButton(context),
        ),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: [
        ListTile(
          leading: Text(device.rssi.toString()),
          title: _buildTitle(context),
          trailing: _buildConnectionButton(context),
        ),
      ],
    );
  }
}