import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothEnableView extends StatefulWidget {
  BluetoothEnableView({
    super.key,
    required this.enableScreen,
    required this.disableScreen,
    required bool isEnable,
    required this.onEnable,
  }) : isEnableValueNotifier = ValueNotifier(isEnable);
  final Widget enableScreen;
  final Widget disableScreen;
  late final ValueNotifier<bool> isEnableValueNotifier;
  final Stream<bool> onEnable;

  @override
  State createState() => _BluetoothEnableViewState();
}

class _BluetoothEnableViewState extends State<BluetoothEnableView> {
  late final StreamSubscription<bool> _onEnable;

  @override
  void initState() {
    super.initState();
    _onEnable = widget.onEnable.listen((isEnable) {
      widget.isEnableValueNotifier.value = isEnable;
    });
  }

  @override
  void dispose() {
    _onEnable.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isEnableValueNotifier,
      builder: (context, isEnable, child) {
        return (isEnable)
          ? widget.enableScreen
          : widget.disableScreen;
      }
    );
  }
}
