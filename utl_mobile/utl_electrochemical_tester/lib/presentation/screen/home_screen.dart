import 'dart:math';

import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/presentation/view/bluetooth/bluetooth_is_on_screen.dart';
import 'package:utl_electrochemical_tester/presentation/view/bluetooth/bluetooth_off_view.dart';
import 'package:utl_electrochemical_tester/presentation/view/bluetooth/bluetooth_scanner_view.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_view.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/electrochemical_line_chart_dashboard.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_line_chart/electrochemical_line_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BluetoothIsOnView(
      builder: (context, isOn) {
        if(!isOn) return const BluetoothOffView();
        final bluetoothScannerView = BluetoothScannerView();
        const electrochemicalLineChart = ElectrochemicalLineChart();
        const electrochemicalLineChartDashboard = ElectrochemicalLineChartDashboard();
        const electrochemicalCommandView = ElectrochemicalCommandView();
        final tabViewMap = {
          const Icon(Icons.bluetooth_searching_rounded):
          bluetoothScannerView,
          const Icon(Icons.list_alt):
          electrochemicalCommandView,
          const Icon(Icons.smart_button_sharp):
          electrochemicalLineChartDashboard,
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
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final mediaQueryData = MediaQuery.of(context);
            final controllerHeight = min(constraints.maxHeight / 2, (constraints.maxHeight - mediaQueryData.viewInsets.vertical));
            return Scaffold(
              body: SafeArea(
                child: Column(children: <Widget>[
                  Expanded(
                    child: electrochemicalLineChart,
                  ),
                  Divider(),
                  SizedBox(
                    height: controllerHeight,
                    child: tabController,
                  ),
                ]),
              ),
            );
          },
        );
      }
    );
  }
}
