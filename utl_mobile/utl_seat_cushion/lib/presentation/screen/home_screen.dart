import 'package:flutter/material.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_is_enabled_screen.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_off_view.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_scanner_view.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/seat_cushion_dashboard_view.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_widget.dart';
import 'package:utl_seat_cushion/resources/widget_resources.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BluetoothIsEnabledView(
          builder: (context, isEnabled) {
            if(!isEnabled) return BluetoothOffView();
            var bluetoothScannerView = BluetoothScannerView();
            var seatCushionDashboardView = SeatCushionDashboardView();
            var tabViewMap = {
              WidgetResources.bluetoothScannerIcon:
              bluetoothScannerView,
              WidgetResources.seatCushionIcon:
              seatCushionDashboardView,
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
            var screen = SafeArea(
              child: Column(children: <Widget>[
                tabBar,
                Expanded(
                  child: tabBarView,
                ),
              ]),
            );
            return screen;
          }
      ),
    );
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