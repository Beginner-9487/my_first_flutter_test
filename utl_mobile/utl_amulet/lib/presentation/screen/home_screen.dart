import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utl_amulet/presentation/view/amulet/amulet_buttons_board.dart';
import 'package:utl_amulet/presentation/view/amulet/amulet_dashboard.dart';
import 'package:utl_amulet/presentation/view/amulet/amulet_line_chart.dart';
import 'package:utl_amulet/presentation/view/bluetooth/bluetooth_is_on_screen.dart';
import 'package:utl_amulet/presentation/view/bluetooth/bluetooth_off_view.dart';
import 'package:utl_amulet/presentation/view/bluetooth/bluetooth_scanner_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return BluetoothIsOnView(
        builder: (context, isOn) {
          if(!isOn) return const BluetoothOffView();
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final mediaQueryData = MediaQuery.of(context);
              final controllerWidth = min(constraints.maxWidth / 3, (constraints.maxWidth - mediaQueryData.viewInsets.horizontal));
              final controllerHeight = min(constraints.maxHeight / 3, (constraints.maxHeight - mediaQueryData.viewInsets.vertical));
              final bluetoothScannerView = BluetoothScannerView();
              const amuletDashboard = AmuletDashboard();
              const amuletButtonsBoard = AmuletButtonsBoard();
              const amuletLineChart = AmuletLineChart();
              final tabViewMap = {
                const Icon(Icons.bluetooth_searching_rounded):
                bluetoothScannerView,
                const Icon(Icons.list_alt):
                amuletDashboard,
              };
              final tabBar = TabBar(
                isScrollable: false,
                tabs: tabViewMap.keys.map((icon) {
                  return Tab(
                    icon: icon,
                  );
                }).toList(),
              );
              final tabView = TabBarView(
                children: tabViewMap.values.toList(),
              );
              final tabController = DefaultTabController(
                length: tabViewMap.length,
                child: Scaffold(
                  appBar: tabBar,
                  body: tabView,
                ),
              );
              return Scaffold(
                body: SafeArea(
                  child: Row(children: <Widget>[
                    const Expanded(
                      child: amuletLineChart,
                    ),
                    const VerticalDivider(),
                    amuletButtonsBoard,
                    const VerticalDivider(),
                    SizedBox(
                      width: controllerWidth,
                      child: tabController,
                    )
                  ]),
                ),
              );
            },
          );
        }
    );
  }
}