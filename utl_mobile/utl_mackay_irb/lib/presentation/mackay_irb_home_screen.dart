import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_auto_connect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_service.dart';
import 'package:utl_mackay_irb/application/use_cases/line_chart_use_case_mackay_irb.dart';
import 'package:utl_mackay_irb/application/use_cases/mackay_irb_ble_task_use_case.dart';
import 'package:utl_mackay_irb/application/use_cases/send_all_ble_use_case.dart';
import 'package:utl_mackay_irb/presentation/bar/ble_command_bar.dart';
import 'package:utl_mackay_irb/resources/app_theme.dart';
import 'package:utl_mackay_irb/resources/global_constants.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_state.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_state.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/presentation/screen/home_screen_abstract.dart';
import 'package:utl_mobile/presentation/view/ble_scanning_view.dart';
import 'package:utl_mobile/presentation/view/line_chart_dashboard_view.dart';
import 'package:utl_mobile/presentation/view/line_chart_view.dart';
import 'package:utl_mobile/presentation/widgets/line_chart_dashboard_tile.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class MackayIRBHomeScreen extends StatefulWidget {
  const MackayIRBHomeScreen({super.key});

  @override
  HomeScreenState<MackayIRBHomeScreen> createState() => _MackayIRBHomeScreenState();
}

class _MackayIRBHomeScreenState extends HomeScreenState<MackayIRBHomeScreen> {
  @override
  BackgroundProcessor backgroundProcessor = GlobalVariables.instance.backgroundProcessor;

  @override
  BLERepository bleRepository = GlobalVariables.instance.bleRepository;

  UpdateBloc lineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc lineChartListenerBloc = LineChartListenerBloc();
  int? get xIndex => lineChartListenerBloc.xIndex;

  final LineChartUseCaseMackayIRB lineChartUseCaseMackayIRB = LineChartUseCaseMackayIRB(
      GlobalVariables.instance.mackayIRBRepository
  );
  BLEMackayIRBService get bleMackayIRBService => GlobalVariables.instance.bleMackayIRBService;

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
  late final LineChartView _lineChartView;

  late SendAllBLEUseCase sendAllBLEUseCase;

  final ValueKey keyYiQin = const ValueKey(0);
  final ValueKey keyTest = const ValueKey(1);
  // final GlobalKey<FormState> keyYiQin = GlobalKey<FormState>();
  // final GlobalKey<FormState> keyTest = GlobalKey<FormState>();
  // static Key keyYiQin = const Key("bleScanningViewYiQin");
  // static Key keyTest = const Key("bleScanningViewTest");
  late BLERepositoryBloc bleRepositoryBlocYiQin;
  late BLERepositoryBloc bleRepositoryBlocTest;
  late Widget bleScanningViewYiQin;
  late Widget bleScanningViewTest;

  @override
  void initState() {
    super.initState();
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
          onExecute: () => {
            MackayIRBBLETaskUseCase(device, bleMackayIRBService).startMackayIRB()
          },
          onTextChange: (BLEDevice device, String text) {
            MackayIRBBLETaskUseCase(device, bleMackayIRBService).setNextName(text);
          },
          colorConnected: AppTheme.bleConnectedColor,
          colorDisconnected: AppTheme.bleDisconnectedColor,
          textConnected: R.str.connect,
          textDisconnected: R.str.disconnect,
        );
      },
    );
    bleScanningViewTest = BLEScanningView(
      key: keyTest,
      bleRepositoryBloc: bleRepositoryBlocTest,
      scannedBLETile: (BLEDevice device) {
        return ScannedBLETile(
          bleDeviceBloc: BLEDeviceBloc(device),
          onConnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.addWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceConnect());
          },
          onDisconnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.removeWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceDisconnect());
          },
          colorConnected: AppTheme.bleConnectedColor,
          colorDisconnected: AppTheme.bleDisconnectedColor,
          textConnected: R.str.connect,
          textDisconnected: R.str.disconnect,
        );
      },
    );

    sendAllBLEUseCase = SendAllBLEUseCase(
      bleRepository,
    );
    _lineChartView = LineChartView(
      updateBloc: lineChartUpdateBloc,
      lineChartListenerBloc: lineChartListenerBloc,
      data: lineChartUseCaseMackayIRB.chartData,
    );
    mackayIRBTabsView = {
      const Icon(Icons.bluetooth_searching_rounded):
      bleScanningViewYiQin,
      const Icon(Icons.bluetooth_searching_rounded):
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BLECommandBar(
          bleRepository: bleRepository,
          sendAllBLEUseCase: sendAllBLEUseCase,
        ),
        body: bleScanningViewTest,
      ),
      const Icon(Icons.add_chart):
      BlocBuilder<LineChartListenerBloc, LineChartState>(
          bloc: lineChartListenerBloc,
          builder: (context, redState) {
            return LineChartDashboardView(
              lineChartListenerBloc: lineChartListenerBloc,
              rows: lineChartUseCaseMackayIRB.dashBoardRows,
              lineChartDashboardTile: (LineChartDashboardRow row) {
                return LineChartDashboardListTile2(
                  color: row.color,
                  labelName: row.name,
                  xLabelName: row.xLabelName,
                  yLabelName: row.yLabelName,
                  xUnitName: row.xUnitName,
                  yUnitName: row.yUnitName,
                  x: (xIndex != null) ? row.points.skip(xIndex!).first.x : null,
                  yList: (xIndex != null && xIndex! < row.points.length)
                      ? row.points
                      .where((element) => element.x.toDouble() == row.points[xIndex!].x)
                      .map((e) => e.y)
                      : null,
                );
              },
            );
          }
      ),
    };
    _onRepositoryUpdate = GlobalVariables.instance.mackayIRBRepository.onNewRowAdded((row) {
      isUpdate = true;
    });
    updateTimer = Timer.periodic(const Duration(milliseconds: updateRate), (Timer timer) {
      if(isUpdate && !lineChartListenerBloc.onTouched) {
        _lineChartView.updateChart(lineChartUseCaseMackayIRB.chartData);
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
    lineChartListenerBloc.add(LineChartEventDispose());
    _onRepositoryUpdate.cancel();
    updateTimer.cancel();
  }
}