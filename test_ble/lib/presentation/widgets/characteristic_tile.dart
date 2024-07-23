import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';
import 'package:test_ble/presentation/widgets/descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BLECharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({super.key, required this.characteristic, required this.descriptorTiles});

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<BLEPacket> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = c.onReadNotifiedData((packet) {
      _value = packet.raw;
      setState(() {});
    });
    writeValueTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BLECharacteristic get c => widget.characteristic;

  String _getWriteBytes() {
    return writeValueTextEditingController.value.text;
  }

  Future onReadPressed() async {
    try {
      await c.readData();
      MessageSnackBar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await BLECommandSentPacketHandlerImplFBP().sentCommandToCharacteristic(c, _getWriteBytes());
      MessageSnackBar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.readData();
      }
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotified == false ? "Subscribe" : "Unsubscribe";
      await c.setNotify(c.isNotified == false);
      MessageSnackBar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.readData();
      }
      setState(() {});
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${c.uuid.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: const Text("Read"),
        onPressed: () async {
          await onReadPressed();
          setState(() {});
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
      child: Text(withoutResp ? "WriteNoResp" : "Write"),
      onPressed: () async {
        await onWritePressed();
        setState(() {});
      }
    );
  }

  Widget buildWriteTextField(BuildContext context) {
    return TextField(
      controller: writeValueTextEditingController,
    );
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = c.isNotified;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed();
          setState(() {});
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
            if (widget.characteristic.properties.write) buildWriteTextField(context),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}