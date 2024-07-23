import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';

class DescriptorTile extends StatefulWidget {
  final BLEDescriptor descriptor;

  const DescriptorTile({super.key, required this.descriptor});

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  List<int> _value = [];

  late StreamSubscription<BLEPacket> _lastValueSubscription;

  late TextEditingController writeValueTextEditingController;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.descriptor.onReadNotifiedData((packet) {
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

  BLEDescriptor get d => widget.descriptor;

  String _getWriteBytes() {
    return writeValueTextEditingController.value.text;
  }

  Future onReadPressed() async {
    try {
      await d.readData();
      MessageSnackBar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await BLECommandSentPacketHandlerImplFBP().sentCommandToDescriptor(d, _getWriteBytes());
      MessageSnackBar.show(ABC.c, "Descriptor Write : Success", success: true);
    } catch (e) {
      MessageSnackBar.show(ABC.c, prettyException("Descriptor Write Error:", e), success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
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
          buildValue(context),
          buildWriteTextField(context),
        ],
      ),
      subtitle: buildButtonRow(context),
    );
  }
}