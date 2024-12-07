import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';
import 'package:test_ble/presentation/widgets/descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BT_Characteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({super.key, required this.characteristic, required this.descriptorTiles});

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  final List<_Value> _value = [];

  late StreamSubscription<BT_Packet> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = c.onReceiveNotifiedPacket((packet) {
      _value.add(_Value(
          value: packet.bytes
      ));
      setState(() {});
    });
    writeValueTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BT_Characteristic get c => widget.characteristic;

  String _getWriteBytes() {
    return writeValueTextEditingController.value.text;
  }

  Future onReadPressed() async {
    try {
      await c.read();
      MessageSnackBar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(BT_Packet_Impl.createByHexString(_getWriteBytes()));
      MessageSnackBar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
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
        await c.read();
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

  Iterable<Widget> buildValue(BuildContext context) {
    return _value.map((e) {
      return Column(
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Row(
            children: [
              Text(
                e.time.toString(),
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                ),
              ),
            ],
          ),
          ...List.generate(
              (e.value.length / 10).ceil(),
                (index) {
                return Row(
                  children: [
                    Text(
                      "${index.toString().padLeft(2, '0')}. ",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey
                      ),
                    ),
                    ...e.value.skip(index * 10).take(10).indexed.map((e) =>
                        Text(
                          e.$2.toRadixString(16).toUpperCase().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 13,
                              color: (e.$1 % 2 == 0) ? Colors.red : Colors.green),
                        )
                    ).toList(),
                  ],
                );
              }
          ),
        ],
      );
    });
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
            ...buildValue(context),
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

class _Value {
  DateTime time;
  Uint8List value;
  _Value({
    required this.value,
  }) : time = DateTime.now();
}