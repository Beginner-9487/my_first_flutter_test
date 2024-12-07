import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';

class DescriptorTile extends StatefulWidget {
  final BT_Descriptor descriptor;

  const DescriptorTile({super.key, required this.descriptor});

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  final List<_Value> _value = [];

  late StreamSubscription<BT_Packet> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.descriptor.onReceiveNotifiedPacket((packet) {
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

  BT_Descriptor get d => widget.descriptor;

  String _getWriteBytes() {
    return writeValueTextEditingController.value.text;
  }

  Future onReadPressed() async {
    try {
      await d.read();
      MessageSnackBar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await d.write(BT_Packet_Impl.createByHexString(_getWriteBytes()));
      MessageSnackBar.show(ABC.c, "Descriptor Write : Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Descriptor Write Error:", e), success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.toUpperCase()}';
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
      onPressed: onReadPressed,
      child: const Text("Read"),
    );
  }

  Widget buildWriteButton(BuildContext context) {
    return TextButton(
      onPressed: onWritePressed,
      child: const Text("Write"),
    );
  }

  Widget buildWriteTextField(BuildContext context) {
    return TextField(
      controller: writeValueTextEditingController,
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildReadButton(context),
        buildWriteButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          ...buildValue(context),
          buildWriteTextField(context),
        ],
      ),
      subtitle: buildButtonRow(context),
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