import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/lock_view/bluetooth_lock_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/off_view/bluetooth_off_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_dashboard_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_off_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_tile.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view.dart';
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
  late final ElectrochemicalCommandController electrochemicalCommandController;
  late final ElectrochemicalDataService electrochemicalDataService;
  late final SharedPreferences sharedPreferences;

  late final BluetoothDashboardView bluetoothDashboardView;
  late final BluetoothOffView disableScreen;
  late final ElectrochemicalCommandView electrochemicalCommandView;
  late final LineChart lineChart;

  late final Map<Icon, Widget> tabViewMap;
  late final TabController tabController;
  late final TabBarView tabBarView;
  late final TabBar tabBar;

  late final Widget enableScreen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bluetoothScannerController = context.read<BluetoothScannerController<BluetoothScannerDeviceTileController>>();
    electrochemicalCommandController = context.read<ElectrochemicalCommandController>();
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
    sharedPreferences = context.read<SharedPreferences>();

    electrochemicalCommandView = ElectrochemicalCommandView(
      controller: electrochemicalCommandController,
      sharedPreferences: sharedPreferences,
    );

    bluetoothDashboardView = BluetoothDashboardView(
      controller: bluetoothScannerController,
      deviceTileBuilder: (device) => BluetoothTile(
          buildContext: context,
          device: device,
      ),
    );

    lineChart = ConcreteLineChart(
        service: electrochemicalDataService,
    );

    tabViewMap = {
      const Icon(Icons.bluetooth_searching_rounded):
      bluetoothDashboardView,
      const Icon(Icons.list_alt):
      electrochemicalCommandView,
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
                child: lineChart,
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

    disableScreen = ConcreteBluetoothOffView(
      context: context,
    );

  }

  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: BluetoothEnableView(
              enableScreen: enableScreen,
              disableScreen: disableScreen,
              isEnable: () => bluetoothScannerController.isEnable,
              onEnable: bluetoothScannerController.onEnableStateChange,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    lineChart.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in background
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
    }
  }
}