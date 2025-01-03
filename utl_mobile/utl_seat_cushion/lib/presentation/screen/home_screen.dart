import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/lock_view/bluetooth_lock_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/off_view/bluetooth_off_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth_off_view.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth_scanner_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late final BluetoothScannerController bluetoothScannerController;

  late final BluetoothScannerView bluetoothScannerView;
  late final Widget enableScreen;
  late final BluetoothOffView disableScreen;

  late final Map<Icon, Widget> tabViewMap;
  late final TabController tabController;
  late final TabBarView tabBarView;
  late final TabBar tabBar;

  late final Widget screen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bluetoothScannerController = context.read<BluetoothScannerController>();

    bluetoothScannerView = BluetoothScannerView(
      controller: bluetoothScannerController,
    );

    tabViewMap = {
      const Icon(Icons.bluetooth_searching_rounded):
      bluetoothScannerView,
      const Icon(Icons.curtains_sharp):
      Scaffold(
        body: TextField(),
      ),
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

    enableScreen = Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          tabBar,
          Expanded(
            child: tabBarView,
          ),
        ]),
      ),
    );

    disableScreen = ConcreteBluetoothOffView(
      context: context,
    );

    screen = Builder(
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
  Widget build(BuildContext context) {
    return screen;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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