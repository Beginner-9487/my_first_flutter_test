import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';

abstract class BluetoothScannerView extends StatefulWidget {
  const BluetoothScannerView({super.key});
  void setFilter(bool Function(BT_Device device)? filter);
  void setTileCreator(Widget Function(BT_Device device) tileCreator);
}
