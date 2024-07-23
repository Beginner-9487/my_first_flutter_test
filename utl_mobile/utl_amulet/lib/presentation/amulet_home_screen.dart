import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_auto_connect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/use_cases/line_chart_use_case_amulet.dart';
import 'package:utl_amulet/application/use_cases/read_file_use_case.dart';
import 'package:utl_amulet/resources/app_theme.dart';
import 'package:utl_amulet/resources/global_constants.dart';
import 'package:utl_amulet/resources/global_variables.dart';
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

class AmuletHomeScreen extends StatefulWidget {
  const AmuletHomeScreen({super.key});

  @override
  HomeScreenState<AmuletHomeScreen> createState() => _AmuletHomeScreenState();
}

class _AmuletHomeScreenState extends HomeScreenState<AmuletHomeScreen> {
  /// Repositories
  @override
  BackgroundProcessor get backgroundProcessor => GlobalVariables.instance.backgroundProcessor;
  @override
  BLERepository get bleRepository => GlobalVariables.instance.bleRepository;

  /// Bloc
  final UpdateBloc _infoFilterButtonBloc = UpdateBloc();

  UpdateBloc lineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc lineChartListenerBloc = LineChartListenerBloc();
  int? get _xIndex => lineChartListenerBloc.xIndex;

  final LineChartUseCaseAmulet lineChartUseCaseAmulet = LineChartUseCaseAmulet(
      GlobalVariables.instance.amuletRepository
  );

  /// Use cases
  final BLESelectedAutoReconnectUseCase bleSelectedAutoReconnectUseCase = BLESelectedAutoReconnectUseCase(
    bleSelectedAutoReconnectService: GlobalVariables.instance.bleSelectedAutoReconnectService,
  );

  final ReadFileUseCase readFileUseCase = ReadFileUseCase(GlobalVariables.instance.amuletRepository);

  /// View
  late TabController _tabViewController;
  late final Map<Icon, Widget> _tabsView;
  late TabBar _tabBar;

  late final _filterButtonView;
  late final BLEScanningView _bleScanningView;
  late final LineChartViewInfo _lineChartView;
  late final LineChartDashboardView _lineChartDashboardView;

  @override
  late final Widget screen;

  /// Timer & StreamSubscription
  bool isUpdate = true;
  bool isStop = false;
  static const int updateRate = GlobalConstants.CHART_UPDATE_RATE;

  late StreamSubscription<AmuletRow> _onRepositoryUpdate;
  late Timer updateTimer;

  @override
  void initState() {
    /// Landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
    /// init View
    /// - Column 0
    _lineChartDashboardView = LineChartDashboardView(
      lineChartListenerBloc: lineChartListenerBloc,
      divider: AppTheme.dividerHorizontal,
      lineChartDashboardTile: (LineChartDashboardRow row) {
        return LineChartDashboardListTile2(
          color: row.color,
          labelName: row.name,
          xLabelName: row.xLabelName,
          yLabelName: row.yLabelName,
          xUnitName: row.xUnitName,
          yUnitName: row.yUnitName,
          x: row.points.first.x,
          yList: (_xIndex != null && _xIndex! < row.points.length)
              ? row.points
                .where((element) => element.x.toDouble() == row.points[_xIndex!].x)
                .map((e) => e.y)
              : null,
        );
      },
    );
    _bleScanningView = BLEScanningView(
      bleRepositoryBloc: bleRepositoryBloc,
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
    _tabsView = {
      const Icon(Icons.bluetooth_searching_rounded):
      _bleScanningView,
      const Icon(Icons.dashboard):
      _lineChartDashboardView,
    };
    _tabViewController = TabController(length: _tabsView.length, vsync: this);
    _tabBar = TabBar(
      isScrollable: false,
      controller: _tabViewController,
      tabs: _tabsView.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );
    /// - Column 1
    _filterButtonView = BlocProvider(
      create: (context) => _infoFilterButtonBloc..add(const UpdateEvent()),
      child: BlocBuilder<UpdateBloc, UpdateState>(
          bloc: _infoFilterButtonBloc,
          builder: (context, state) {
            return Column(
              children: [
                IconButton(
                  color: (lineChartUseCaseAmulet.showAcc) ? AppTheme.bleConnectedColor : null,
                  onPressed: () {
                    lineChartUseCaseAmulet.showAcc = !lineChartUseCaseAmulet.showAcc;
                    lineChartListenerBloc.add(LineChartEventRefresh());
                    _infoFilterButtonBloc.add(const UpdateEvent());
                  },
                  icon: const Icon(Icons.directions_run),
                ),
                IconButton(
                  color: (lineChartUseCaseAmulet.showGyro) ? AppTheme.bleConnectedColor : null,
                  onPressed: () {
                    lineChartUseCaseAmulet.showGyro = !lineChartUseCaseAmulet.showGyro;
                    lineChartListenerBloc.add(LineChartEventRefresh());
                    _infoFilterButtonBloc.add(const UpdateEvent());
                  },
                  icon: const Icon(Icons.sports_gymnastics_rounded),
                ),
                IconButton(
                  color: (lineChartUseCaseAmulet.showMag) ? AppTheme.bleConnectedColor : null,
                  onPressed: () {
                    lineChartUseCaseAmulet.showMag = !lineChartUseCaseAmulet.showMag;
                    lineChartListenerBloc.add(LineChartEventRefresh());
                    _infoFilterButtonBloc.add(const UpdateEvent());
                  },
                  icon: const Icon(Icons.usb_outlined),
                ),
                IconButton(
                  color: (lineChartUseCaseAmulet.showOthers) ? AppTheme.bleConnectedColor : null,
                  onPressed: () {
                    lineChartUseCaseAmulet.showOthers = !lineChartUseCaseAmulet.showOthers;
                    lineChartListenerBloc.add(LineChartEventRefresh());
                    _infoFilterButtonBloc.add(const UpdateEvent());
                  },
                  icon: const Icon(Icons.list_alt),
                ),
                const Spacer(),
                IconButton(
                  color: (isStop) ? AppTheme.bleDisconnectedColor : null,
                  onPressed: () {
                    isStop = !isStop;
                    lineChartListenerBloc.add(LineChartEventRefresh());
                    _infoFilterButtonBloc.add(const UpdateEvent());
                  },
                  icon: const Icon(Icons.stop),
                ),
                IconButton(
                  color: null,
                  onPressed: () {
                    readFileUseCase.readAmuletFile();
                  },
                  icon: const Icon(Icons.file_upload),
                ),
              ],
            );
          }),
    );
    /// - Column 2
    _lineChartView = LineChartViewInfo(
      updateBloc: lineChartUpdateBloc,
      lineChartListenerBloc: lineChartListenerBloc,
    );
    /// final
    screen = Scaffold(
      body: SafeArea(
        child: Row(children: <Widget>[
          Expanded(
              child: Column(
                children: [
                  _tabBar,
                  Expanded(
                    child: TabBarView(
                        controller: _tabViewController,
                        children: _tabsView.values
                            .map((page) => page)
                            .toList(),
                    ),
                  ),
                ],
              ),
          ),
          AppTheme.dividerVertical,
          _filterButtonView,
          AppTheme.dividerVertical,
          Expanded(
            child: _lineChartView,
          ),
        ]),
      ),
    );
    /// init Timer
    _onRepositoryUpdate = GlobalVariables.instance.amuletRepository.onAdd((row) {
      isUpdate = true;
    });
    updateTimer = Timer.periodic(const Duration(milliseconds: updateRate), (Timer timer) {
      if(isUpdate && !isStop && !lineChartListenerBloc.onTouched) {
        _lineChartView.updateChart(lineChartUseCaseAmulet.chartData);
        _lineChartDashboardView.updateChart(lineChartUseCaseAmulet.dashBoardRows);
        lineChartUpdateBloc.add(const UpdateEvent());
        isUpdate = false;
      }
    });
    /// StreamSubscription
  }

  @override
  Widget build(BuildContext context) {
    R.set(context);
    return Builder(
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: backgroundWorkHeader,
          // appBar: _tabBar,
          body: fullScreen,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    lineChartListenerBloc.add(LineChartEventDispose());
    _onRepositoryUpdate.cancel();
    updateTimer.cancel();
  }
}