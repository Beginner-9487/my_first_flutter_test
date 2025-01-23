import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/presentation/view/bluetooth/bluetooth_is_enabled_screen.dart';
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
    return BluetoothIsEnabledView(
      builder: (context, isEnabled) {
        if(!isEnabled) return BluetoothOffView();
        var bluetoothScannerView = BluetoothScannerView();
        var electrochemicalLineChart = ElectrochemicalLineChart();
        var electrochemicalLineChartDashboard = ElectrochemicalLineChartDashboard();
        var electrochemicalCommandView = ElectrochemicalCommandView();
        var tabViewMap = {
          const Icon(Icons.bluetooth_searching_rounded):
          bluetoothScannerView,
          const Icon(Icons.list_alt):
          electrochemicalCommandView,
          const Icon(Icons.smart_button_sharp):
          electrochemicalLineChartDashboard,
        };
        var tabBar = TabBar(
          isScrollable: false,
          tabs: tabViewMap.keys.map((icon) {
            return Tab(
              icon: icon,
            );
          }).toList(),
        );
        var tabView = TabBarView(
          children: tabViewMap.values.toList(),
        );
        var tabController = DefaultTabController(
          length: tabViewMap.length,
          child: Scaffold(
            appBar: AppBar(
              bottom: tabBar,
            ),
            body: Expanded(
              child: tabView,
            ),
          ),
        );
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Scaffold(
              body: SafeArea(
                child: Column(children: <Widget>[
                  Expanded(
                    child: electrochemicalLineChart,
                  ),
                  Divider(),
                  tabBar,
                  SizedBox(
                    height: constraints.maxHeight / 2,
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
