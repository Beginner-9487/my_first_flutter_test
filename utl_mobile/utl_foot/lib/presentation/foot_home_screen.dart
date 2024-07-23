import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_auto_connect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/services/ble_foot_service.dart';
import 'package:utl_foot/application/use_cases/save_file_use_case.dart';
import 'package:utl_foot/application/use_cases/foot_map_use_case.dart';
import 'package:utl_foot/application/use_cases/line_chart_use_case_foot_imu.dart';
import 'package:utl_foot/application/use_cases/save_file_use_case_row.dart';
import 'package:utl_foot/application/use_cases/send_all_ble_use_case.dart';
import 'package:utl_foot/presentation/bar/ble_and_file_controller_bar.dart';
import 'package:utl_foot/presentation/foot_map_view.dart';
import 'package:utl_foot/resources/app_theme.dart';
import 'package:utl_foot/resources/global_constants.dart';
import 'package:utl_foot/resources/global_variables.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_state.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/presentation/screen/home_screen_abstract.dart';
import 'package:utl_mobile/presentation/view/ble_scanning_view.dart';
import 'package:utl_mobile/presentation/view/line_chart_view.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class FootHomeScreen extends StatefulWidget {
  const FootHomeScreen({super.key});

  @override
  HomeScreenState<FootHomeScreen> createState() => _FootHomeScreenState();
}

class _FootHomeScreenState extends HomeScreenState<FootHomeScreen> {
  @override
  BackgroundProcessor backgroundProcessor = GlobalVariables.instance.backgroundProcessor;

  @override
  BLERepository bleRepository = GlobalVariables.instance.bleRepository;

  late SendAllBLEUseCase sendAllBLEUseCase;

  UpdateBloc mapUpdateBloc = UpdateBloc();
  UpdateBloc lineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc lineChartListenerBloc = LineChartListenerBloc();

  final FootMapUseCase footMapUseCase = FootMapUseCase(
      GlobalVariables.instance
  );
  final LineChartUseCaseFootIMU lineChartUseCaseFootIMU = LineChartUseCaseFootIMU(
      GlobalVariables.instance
  );
  BLEFootService get bleFootService => GlobalVariables.instance.bleFootService;

  final BLESelectedAutoReconnectUseCase bleSelectedAutoReconnectUseCase = BLESelectedAutoReconnectUseCase(
    bleSelectedAutoReconnectService: GlobalVariables.instance.bleSelectedAutoReconnectService,
  );

  final SaveFileUseCase saveFileUseCase = SaveFileUseCaseRow(GlobalVariables.instance);

  late TabController _footTabViewController;
  late TabBar _footTabBar;
  late final Map<Icon, Widget> footTabsView;

  bool isIMUUpdate = true;
  late StreamSubscription<FootEntity> _onIMUUpdate;
  static const int imuUpdateRate = GlobalConstants.IMU_LINE_CHART_UPDATE_RATE;
  late Timer imuUpdateTimer;

  bool isMapUpdate = true;
  late StreamSubscription<FootEntity> _onMapUpdate;
  static const int mapUpdateRate = GlobalConstants.MAP_UPDATE_RATE;
  late Timer mapUpdateTimer;

  @override
  late final Widget screen;

  late final LineChartViewInfo _lineChartViewIMU;

  late final Widget bleToolBarView;
  late final UpdateBloc _isSavingFileBloc = UpdateBloc();
  late final TextEditingController _bleCommandController;
  late StreamSubscription<bool> _onSavingFile;
  Widget get bleScanningView => BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
      bloc: bleRepositoryBloc,
      builder: (context, redState) {
        return BLEScanningView(
          bleRepositoryBloc: bleRepositoryBloc,
          scannedBLETile: (BLEDevice device) {
            return ScannedBLETile(
              bleDeviceBloc: BLEDeviceBloc(device),
              colorConnected: AppTheme.bleConnectedColor,
              colorDisconnected: AppTheme.bleDisconnectedColor,
              textConnected: R.str.connect,
              textDisconnected: R.str.disconnect,
              onConnect: (BLEDeviceBloc bleDeviceBloc) {
                bleSelectedAutoReconnectUseCase.addWantedAutoConnect(device);
                bleDeviceBloc.add(BLEDeviceConnect());
              },
              onDisconnect: (BLEDeviceBloc bleDeviceBloc) {
                bleSelectedAutoReconnectUseCase.removeWantedAutoConnect(device);
                bleDeviceBloc.add(BLEDeviceDisconnect());
              },
            );
          },
        );
      }
  );

  @override
  void initState() {
    sendAllBLEUseCase = SendAllBLEUseCase(
      GlobalVariables.instance,
    );
    _onSavingFile = saveFileUseCase.onSavingFile((bool state) {
      _isSavingFileBloc.add(const UpdateEvent());
    });
    _lineChartViewIMU = LineChartViewInfo(
      updateBloc: lineChartUpdateBloc,
      lineChartListenerBloc: lineChartListenerBloc,
      data: lineChartUseCaseFootIMU.chartData,
    );
    super.initState();
    footTabsView = {
      const Icon(Icons.bluetooth_searching_rounded):
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BLEAndFileControllerBar(
          isSavingFileBloc: _isSavingFileBloc,
          bleRepository: bleRepository,
          saveFileUseCase: saveFileUseCase,
          sendAllBLEUseCase: sendAllBLEUseCase,
        ),
        body: bleScanningView,
      ),
      // BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
      //     bloc: bleRepositoryBloc,
      //     builder: (context, redState) {
      //       return BLEScanningView(
      //         bleRepositoryBloc: bleRepositoryBloc,
      //         scannedBLETile: (BLEDevice device) {
      //           return ScannedBLETile(
      //             bleDeviceBloc: BLEDeviceBloc(device),
      //             colorConnected: AppTheme.bleConnectedColor,
      //             colorDisconnected: AppTheme.bleDisconnectedColor,
      //             textConnected: R.str.connect,
      //             textDisconnected: R.str.disconnect,
      //             onConnect: () {
      //               bleSelectedAutoReconnectUseCase.addWantedAutoConnect(device);
      //               device.connect();
      //             },
      //             onDisconnect: () {
      //               bleSelectedAutoReconnectUseCase.removeWantedAutoConnect(device);
      //               device.disconnect();
      //             },
      //           );
      //         },
      //       );
      //     }
      // ),
      // const Icon(Icons.file_copy):
      // bleToolBarView,
      const Icon(Icons.near_me_sharp):
      BlocBuilder<UpdateBloc, UpdateState>(
          bloc: mapUpdateBloc,
          builder: (context, redState) {
            return FootMapView(
              updateBloc: mapUpdateBloc,
              mapData: footMapUseCase.sensorData,
            );
          }
      ),
      const Icon(Icons.add_chart):
      _lineChartViewIMU,
    };
    _onMapUpdate = GlobalVariables.instance.footRepository.onNewRowAdded((entity) {
      isMapUpdate = true;
    });
    mapUpdateTimer = Timer.periodic(const Duration(milliseconds: mapUpdateRate), (Timer timer) {
      if(isMapUpdate) {
        mapUpdateBloc.add(const UpdateEvent());
        isMapUpdate = false;
      }
    });
    _onIMUUpdate = GlobalVariables.instance.footRepository.onNewRowAdded((entity) {
      isIMUUpdate = true;
    });
    imuUpdateTimer = Timer.periodic(const Duration(milliseconds: imuUpdateRate), (Timer timer) {
      // if(isIMUUpdate && !lineChartBloc.onTouched && !autoSaveFileService.isSavingFile) {
      if(isIMUUpdate && !lineChartListenerBloc.onTouched) {
        _lineChartViewIMU.updateChart(lineChartUseCaseFootIMU.chartData);
        lineChartUpdateBloc.add(const UpdateEvent());
        isIMUUpdate = false;
      }
    });
    _footTabViewController = TabController(length: footTabsView.length, vsync: this);
    _footTabBar = TabBar(
      isScrollable: false,
      controller: _footTabViewController,
      tabs: footTabsView.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );
    screen = Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          _footTabBar,
          AppTheme.divider,
          BlocProvider(
            create: (context) => bleRepositoryBloc,
            child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
                bloc: bleRepositoryBloc,
                builder: (context, state) {
                  return Expanded(
                    child: TabBarView(
                      controller: _footTabViewController,
                      children: footTabsView.values
                          .map((page) => page)
                          .toList(),
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }
}