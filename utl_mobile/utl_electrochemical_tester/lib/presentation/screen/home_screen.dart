import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_lock_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_lock_view_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/application/controller/bt_controller.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_scanner_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_line_chart_dashboard_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_tester_view.dart';
import 'package:utl_electrochemical_tester/resources/app_theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
    required this.bt_controller,
    required this.contextResource,
    required this.electrochemical_line_chart_controller,
    required this.sharedPreferences,
  });

  BT_Controller bt_controller;
  ContextResource contextResource;
  Electrochemical_Line_Chart_Controller electrochemical_line_chart_controller;
  SharedPreferences sharedPreferences;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  BT_Controller get bt_controller => widget.bt_controller;
  ContextResource get contextResource => widget.contextResource;
  Electrochemical_Line_Chart_Controller get electrochemical_line_chart_controller => widget.electrochemical_line_chart_controller;
  SharedPreferences get sharedPreferences => widget.sharedPreferences;

  late final Bluetooth_Scanner_View bluetooth_scanner_view;
  late final Electrochemical_Tester_View electrochemical_tester_view;
  late final Electrochemical_Line_Chart_View electrochemical_line_chart_view;
  late final Electrochemical_Line_Chart_Dashboard_View electrochemical_line_chart_dashboard_view;

  late final Map<Icon, Widget> tabViewMap;
  late final TabController tabController;
  late final TabBarView tabBarView;
  late final TabBar tabBar;

  late final Widget mainScreen;

  late final BluetoothLockView bluetoothLockView;

  late final Builder finalScreen;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    bluetooth_scanner_view = Bluetooth_Scanner_View_Impl(
      bt_controller: bt_controller,
      contextResource: contextResource,
    );
    electrochemical_tester_view = Electrochemical_Tester_View(
      bt_controller: bt_controller,
      contextResource: contextResource,
      sharedPreferences: sharedPreferences,
    );
    electrochemical_line_chart_view = Electrochemical_Line_Chart_View_Impl(
      electrochemical_line_chart_controller: electrochemical_line_chart_controller,
    );
    electrochemical_line_chart_dashboard_view = Electrochemical_Line_Chart_Dashboard_View_Impl(
      contextResource: contextResource,
      electrochemical_line_chart_controller: electrochemical_line_chart_controller,
      divider_data: AppTheme.divider,
      divider_item: AppTheme.divider,
    );

    tabViewMap = {
      const Icon(Icons.bluetooth_searching_rounded):
      bluetooth_scanner_view,
      const Icon(Icons.list_alt):
      electrochemical_tester_view,
      const Icon(Icons.add_chart):
      electrochemical_line_chart_dashboard_view,
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


    mainScreen = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.minWidth;
        height = constraints.maxHeight;
        return Scaffold(
          body: SafeArea(
            child: Column(children: <Widget>[
              Expanded(
                child: electrochemical_line_chart_view,
              ),
              AppTheme.divider,
              tabBar,
              Container(
                color: AppTheme.line_chart_background_color,
                height: height / 2,  // Also Including Tab-bar height.
                child: tabBarView,
              ),
            ]),
          ),
        );
      },
    );

    bluetoothLockView = BluetoothLockViewImpl(
      provider: bt_controller.bt_provider,
      mainScreen: mainScreen,
    );

    finalScreen = Builder(
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: BluetoothLockViewImpl(
            provider: bt_controller.bt_provider,
            mainScreen: mainScreen,
          ),
        );
      },
    );
  }

  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    contextResource.setContext(context);
    return finalScreen;
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