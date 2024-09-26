import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_auto_connect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_data_setter.dart';
import 'package:utl_mackay_irb/application/use_cases/mackay_irb_ble_task_use_case.dart';
import 'package:utl_mackay_irb/application/use_cases/send_all_ble_use_case.dart';
import 'package:utl_mackay_irb/presentation/bar/ble_command_bar.dart';
import 'package:utl_mackay_irb/presentation/view/mackay_irb_line_chart.dart';
import 'package:utl_mackay_irb/presentation/view/mackay_irb_line_chart_dashboard.dart';
import 'package:utl_mackay_irb/resources/app_theme.dart';
import 'package:utl_mackay_irb/resources/global_constants.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_state.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/presentation/screen/home_screen_abstract.dart';
import 'package:utl_mobile/presentation/view/ble_scanning_view.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class MackayIRBHomeScreen extends StatefulWidget {
  const MackayIRBHomeScreen({super.key});

  @override
  HomeScreenState<MackayIRBHomeScreen> createState() => _MackayIRBHomeScreenState();
}

class _MackayIRBHomeScreenState extends HomeScreenState<MackayIRBHomeScreen> with WidgetsBindingObserver {
  @override
  BackgroundProcessor backgroundProcessor = GlobalVariables.instance.backgroundProcessor;

  @override
  BLERepository bleRepository = GlobalVariables.instance.bleRepository;

  UpdateBloc lineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc lineChartListenerBloc = LineChartListenerBloc();
  int? get xIndex => lineChartListenerBloc.xIndex;

  BLEMackayIRBDataSetter get bleMackayIRBDataSetter => GlobalVariables.instance.bleMackayIRBDataSetter;

  final BLESelectedAutoReconnectUseCase bleSelectedAutoReconnectUseCase = BLESelectedAutoReconnectUseCase(
    bleSelectedAutoReconnectService: GlobalVariables.instance.bleSelectedAutoReconnectService,
  );

  late TabController _mackayIRBTabViewController;
  late TabBar _mackayIRBTabBar;
  late final Map<Icon, Widget> mackayIRBTabsView;

  bool isUpdate = true;
  late StreamSubscription<MackayIRBRow> _onRepositoryUpdate;
  static const int updateRate = GlobalConstants.CHART_UPDATE_RATE;
  late Timer updateTimer;

  @override
  late Widget screen;
  late final MackayIRBLineChart _lineChartView;

  late SendAllBLEUseCase sendAllBLEUseCase;

  final ValueKey keyYiQin = const ValueKey(0);
  final ValueKey keyTest = const ValueKey(1);
  late BLERepositoryBloc bleRepositoryBlocYiQin;
  late BLERepositoryBloc bleRepositoryBlocTest;
  late Widget bleScanningViewYiQin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bleRepositoryBlocYiQin = BLERepositoryBloc(
      bleRepository,
    );
    bleRepositoryBlocTest = BLERepositoryBloc(
      bleRepository,
    );
    bleScanningViewYiQin = BLEScanningView(
      key: keyYiQin,
      bleRepositoryBloc: bleRepositoryBlocYiQin,
      scannedBLETile: (BLEDevice device) {
        return ScannedBLEExecuteTextTile(
          bleDeviceBloc: BLEDeviceBloc(device),
          onConnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.addWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceConnect());
          },
          onDisconnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.removeWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceDisconnect());
          },
          onExecute: (BLEDevice device, String text) {
            if(text == "") {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
                width: 280,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                onDismissCallback: (type) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dismissed by $type'),
                    ),
                  );
                },
                headerAnimationLoop: false,
                animType: AnimType.bottomSlide,
                title: R.str.name,
                showCloseIcon: true,
                btnCancelOnPress: () {},
                btnOkOnPress: () {},
              ).show();
              return;
            }
            MackayIRBBLETaskUseCase(device, bleMackayIRBDataSetter).setName(text);
            MackayIRBBLETaskUseCase(device, bleMackayIRBDataSetter).startMackayIRB();
          },
          onTextChange: (BLEDevice device, String text) {
            // MackayIRBBLETaskUseCase(device, bleMackayIRBDataSetter).setNextName(text);
          },
          colorConnected: AppTheme.bleConnectedColor,
          colorDisconnected: AppTheme.bleDisconnectedColor,
          textConnected: R.str.connect,
          textDisconnected: R.str.disconnect,
          textDefault: MackayIRBBLETaskUseCase(device, bleMackayIRBDataSetter).getName(),
        );
      },
    );

    sendAllBLEUseCase = SendAllBLEUseCase(
      bleRepository,
    );
    _lineChartView = MackayIRBLineChart(
      updateBloc: lineChartUpdateBloc,
      lineChartListenerBloc: lineChartListenerBloc,
      mackayIRBRepository: MackayIRBRepositoryImpl.getInstance(),
    );
    mackayIRBTabsView = {
      const Icon(Icons.bluetooth_searching_rounded):
      bleScanningViewYiQin,
      // const Icon(Icons.bluetooth_searching_rounded):
      // Scaffold(
      //   extendBodyBehindAppBar: true,
      //   appBar: BLECommandBar(
      //     bleRepository: bleRepository,
      //     sendAllBLEUseCase: sendAllBLEUseCase,
      //   ),
      //   body: bleScanningViewTest,
      // ),
      const Icon(Icons.add_chart):
      BlocBuilder<LineChartListenerBloc, LineChartState>(
          bloc: lineChartListenerBloc,
          builder: (context, redState) {
            return MackayIRBLineChartDashBoard(
              mackayIRBRepository: MackayIRBRepositoryImpl.getInstance(),
              lineChartListenerBloc: lineChartListenerBloc,
              divider_item: AppTheme.divider,
              divider_data: AppTheme.divider2,
            );
          }
      ),
    };
    _onRepositoryUpdate = GlobalVariables.instance.mackayIRBRepository.onNewRowAdded((row) {
      isUpdate = true;
    });
    updateTimer = Timer.periodic(const Duration(milliseconds: updateRate), (Timer timer) {
      if(isUpdate && !lineChartListenerBloc.onTouched) {
        _lineChartView.updateChart();
        lineChartUpdateBloc.add(const UpdateEvent());
        isUpdate = false;
      }
    });
    _mackayIRBTabViewController = TabController(length: mackayIRBTabsView.length, vsync: this);
    _mackayIRBTabBar = TabBar(
      isScrollable: false,
      controller: _mackayIRBTabViewController,
      tabs: mackayIRBTabsView.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );
  }

  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    screen = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.minWidth;
        height = constraints.maxHeight;
        return Scaffold(
          body: SafeArea(
            child: Column(children: <Widget>[
              Container(
                color: AppTheme.headerColor,
                height: height / 2,  // Also Including Tab-bar height.
                child: _lineChartView,
              ),
              AppTheme.divider,
              _mackayIRBTabBar,
              Expanded(
                child: TabBarView(
                  controller: _mackayIRBTabViewController,
                  children: mackayIRBTabsView.values
                      .map((page) => page)
                      .toList(),
                ),
              ),
            ]),
          ),
        );
      },
    );
    return super.build(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    lineChartListenerBloc.add(LineChartEventDispose());
    _onRepositoryUpdate.cancel();
    updateTimer.cancel();
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