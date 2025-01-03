import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/lock_view/bluetooth_lock_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/off_view/bluetooth_off_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_scanner_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_off_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_tile.dart';
import 'package:utl_electrochemical_tester/presentation/subview/dashboard_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/concrete_line_chart_view.dart';
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
  late final BluetoothScannerController<BluetoothScannerDeviceTileController> bluetoothScannerController;

  late final BluetoothScannerView bluetoothScannerView;
  late final BluetoothOffView disableScreen;
  late final ElectrochemicalCommandView electrochemicalCommandView;
  late final LineChartView lineChartView;
  late final LineChartModeController lineChartModeController;
  late final LineChartTypesController lineChartTypesController;
  late final DashboardView dashboardView;

  late final Map<Icon, Widget> tabViewMap;
  late final TabController tabController;
  late final TabBarView tabBarView;
  late final TabBar tabBar;

  late final Widget enableScreen;

  late final Widget screen;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bluetoothScannerController = context.read<BluetoothScannerController<BluetoothScannerDeviceTileController>>();

    electrochemicalCommandView = ElectrochemicalCommandView();

    bluetoothScannerView = BluetoothScannerView(
      controller: bluetoothScannerController,
      deviceTileBuilder: (device) => BluetoothTile(
        controller: device,
      ),
    );

    lineChartModeController = LineChartModeController();
    lineChartTypesController = LineChartTypesController();
    lineChartView = ConcreteLineChartView(
      lineChartModeController: lineChartModeController,
      lineChartTypesController: lineChartTypesController,
      onTouchStateChanged: (oldState, newState) {
        dashboardView.x = newState.x;
      },
    );

    dashboardView = DashboardView(
      lineChartModeController: lineChartModeController,
      lineChartTypesController: lineChartTypesController,
    );

    tabViewMap = {
      const Icon(Icons.bluetooth_searching_rounded):
      bluetoothScannerView,
      const Icon(Icons.list_alt):
      electrochemicalCommandView,
      const Icon(Icons.smart_button_sharp):
      dashboardView,
    };

    tabController = TabController(
        length: tabViewMap.length,
        vsync: this,
    );

    tabBarView = TabBarView(
      controller: tabController,
      children: tabViewMap.values.toList(),
    );

    tabBar = TabBar(
      isScrollable: false,
      controller: tabController,
      tabs: tabViewMap.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );


    enableScreen = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.minWidth;
        height = constraints.maxHeight;
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
                height: height / 2,  // Also Including Tab-bar height.
                child: tabBarView,
              ),
            ]),
          ),
        );
      },
    );

    disableScreen = ConcreteBluetoothOffView();

    screen = Builder(
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: BluetoothEnableView(
            enableScreen: enableScreen,
            disableScreen: disableScreen,
            isEnable: bluetoothScannerController.isEnable,
            onEnable: bluetoothScannerController.onEnableStateChange,
          ),
        );
      },
    );

  }

  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    return screen;
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}