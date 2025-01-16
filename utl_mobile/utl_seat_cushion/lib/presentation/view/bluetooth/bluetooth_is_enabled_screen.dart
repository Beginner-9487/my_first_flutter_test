import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_widget_util.dart';

class BluetoothIsEnabledView extends StatelessWidget {
  BluetoothIsEnabledView({
    super.key,
    required this.builder,
  });
  Widget Function(BuildContext context, bool isEnabled) builder;
  @override
  Widget build(BuildContext context) {
    return FlutterBluePlusWidgetUtil.buildIsEnabledWidget(
      builder: builder,
    );
  }
}
