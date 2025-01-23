import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_scanner_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_is_enabled_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/dashboard_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/concrete_line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/electrochemical_command_view.dart';
import 'package:utl_electrochemical_tester/resources/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late final LineChartInfoController lineChartInfoController;
  late final LineChartModeController lineChartModeController;
  late final LineChartTypesController lineChartTypesController;
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    lineChartInfoController = LineChartInfoController();
    lineChartModeController = LineChartModeController();
    lineChartTypesController = LineChartTypesController();
  }
  @override
  Widget build(BuildContext context) {
    return ConcreteBluetoothIsEnabledView(
        builder: (context, isEnabled) {
          if(!isEnabled) {
            return ConcreteBluetoothOffView();
          }
          var bluetoothScannerView = BluetoothScannerView();
          var lineChartView = ConcreteLineChartView(
            lineChartModeController: lineChartModeController,
            lineChartTypesController: lineChartTypesController,
            onTouchStateChanged: (state) {
              if(state.x == null) return;
              lineChartInfoController.x = state.x;
            },
          );
          var dashboardView = DashboardView(
            lineChartInfoController: lineChartInfoController,
            lineChartModeController: lineChartModeController,
            lineChartTypesController: lineChartTypesController,
          );
          var electrochemicalCommandView = ElectrochemicalCommandView();
          var tabViewMap = {
            const Icon(Icons.bluetooth_searching_rounded):
            bluetoothScannerView,
            const Icon(Icons.list_alt):
            electrochemicalCommandView,
            const Icon(Icons.smart_button_sharp):
            dashboardView,
          };
          var tabController = TabController(
            length: tabViewMap.length,
            vsync: this,
          );
          var tabBarView = TabBarView(
            controller: tabController,
            children: tabViewMap.values.toList(),
          );
          var tabBar = TabBar(
            isScrollable: false,
            controller: tabController,
            tabs: tabViewMap.keys.map((title) {
              return Tab(
                icon: title,
              );
            }).toList(),
          );
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Scaffold(
                body: SafeArea(
                  child: Column(children: <Widget>[
                    Expanded(
                      child: lineChartView,
                    ),
                    AppTheme.divider,
                    tabBar,
                    Container(
                      color: AppTheme.lineChartBackgroundColor,
                      height: constraints.maxHeight / 2,  // Also Including Tab-bar height.
                      child: tabBarView,
                    ),
                  ]),
                ),
              );
            },
          );
        }
    );
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    lineChartInfoController.dispose();
    lineChartModeController.dispose();
    lineChartTypesController.dispose();
    super.dispose();
  }
}