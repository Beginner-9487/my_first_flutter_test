import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_auto_connect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:utl_leakage/application/domain/leakage_repository.dart';
import 'package:utl_leakage/application/use_cases/check_warning_use_case.dart';
import 'package:utl_leakage/application/use_cases/extra_leakage_line_chart_use_case.dart';
import 'package:utl_leakage/application/use_cases/intra_osmosis_line_chart_use_case.dart';
import 'package:utl_leakage/resources/app_image.dart';
import 'package:utl_leakage/resources/app_sound.dart';
import 'package:utl_leakage/resources/app_theme.dart';
import 'package:utl_leakage/resources/global_variables.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_state.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/presentation/view/ble_scanning_view.dart';
import 'package:utl_mobile/presentation/view/bluetooth_off_screen.dart';
import 'package:utl_mobile/presentation/view/line_chart_view.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BackgroundProcessor backgroundProcessor = GlobalVariables.instance.backgroundProcessor;
  BLERepository get bleRepository => GlobalVariables.instance.bleRepository;
  BLERepositoryBloc bleRepositoryBloc = BLERepositoryBloc(
      GlobalVariables.instance.bleRepository,
  );
  bool get isBluetoothOn => bleRepository.isBluetoothOn;

  final CheckWarningUseCase _checkWarningUseCase = CheckWarningUseCase(GlobalVariables.instance.leakageRepository);
  bool previousIsExtraLeakage = false;
  bool previousIsIntraOsmosis = false;
  late final StreamSubscription _onExtraLeakage;
  late final StreamSubscription _onIntraOsmosis;

  UpdateBloc extraLeakageWarningImageUpdateBloc = UpdateBloc();
  UpdateBloc extraLeakageLineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc extraLeakageLineChartListenerBloc = LineChartListenerBloc();
  UpdateBloc intraOsmosisWarningImageUpdateBloc = UpdateBloc();
  UpdateBloc intraOsmosisLineChartUpdateBloc = UpdateBloc();
  LineChartListenerBloc intraOsmosisLineChartListenerBloc = LineChartListenerBloc();

  final ExtraLeakageLineChartUseCase extraLeakageLineChartUseCase = ExtraLeakageLineChartUseCase(
      GlobalVariables.instance.leakageRepository
  );
  final IntraOsmosisLineChartUseCase intraOsmosisLineChartUseCase = IntraOsmosisLineChartUseCase(
      GlobalVariables.instance.leakageRepository
  );
  final BLESelectedAutoReconnectUseCase bleSelectedAutoReconnectUseCase = BLESelectedAutoReconnectUseCase(
    bleSelectedAutoReconnectService: GlobalVariables.instance.bleSelectedAutoReconnectService,
  );

  bool get isDeviceConnected => bleRepository.connectedDevices.isNotEmpty;
  late StreamSubscription<LeakageRow> _onRepositoryUpdate;
  late final Widget bleScanningView;
  late final Widget _extraLeakageLineChartView;
  late final Widget _intraOsmosisLineChartView;

  double get warningImageSize {
    if(screenWidth(context) > screenHeight(context)) {
      return screenHeight(context) / 1.5;
    } else {
      return screenWidth(context) / 1.5;
    }
  }

  startWarning() {
    FlutterRingtonePlayer.play(
      fromAsset: AppSound.WARNING,
      looping: true,
    );
  }
  stopWarning() {
    FlutterRingtonePlayer.stop();
  }

  AppBar get appBar {
    return AppBar();
  }

  Widget get imageExtraLeakage {
    return Positioned(
      // left: (screenWidth(context) - warningImageSize) / 2, // Adjust this value to position horizontally
      // top: (screenHeight(context) - warningImageSize) / 2, // Adjust this value to position vertically
      left: leftExtraLeakageLineChart, // Adjust this value to position horizontally
      top: topExtraLeakageLineChart, // Adjust this value to position vertically
      child: SizedBox(
        width: warningImageSize, // Set your SVG image width
        height: warningImageSize, // Set your SVG image height
        child: SvgPicture.asset(
          AppImage.svgExtraLeakageLOGO, // Path to your SVG image
        ),
      ),
    );
  }

  Widget get imageIntraOsmosis {
    return Positioned(
      // left: (screenWidth(context) - warningImageSize) / 2, // Adjust this value to position horizontally
      // top: (screenHeight(context) - warningImageSize) / 2, // Adjust this value to position vertically
      left: leftIntraOsmosisLineChart, // Adjust this value to position horizontally
      top: topIntraOsmosisLineChart, // Adjust this value to position vertically
      child: SizedBox(
        width: warningImageSize, // Set your SVG image width
        height: warningImageSize, // Set your SVG image height
        child: SvgPicture.asset(
          AppImage.svgIntraOsmosisLOGO, // Path to your SVG image
        ),
      ),
    );
  }

  @override
  Widget get screen {
    late Widget widget;
    if(isBluetoothOn) {
      if(isDeviceConnected) {
        widget = Builder(
          builder: (context) {
            return Scaffold(
              // extendBodyBehindAppBar: true,
              appBar: appBar,
              body: Stack(
                children: [
                  Column(
                    children: [
                      _extraLeakageLineChartView,
                      AppTheme.divider,
                      _intraOsmosisLineChartView,
                    ],
                  ),
                  BlocProvider(
                      create: (context) => extraLeakageWarningImageUpdateBloc,
                      child: BlocBuilder<UpdateBloc, UpdateState>(
                          bloc: extraLeakageWarningImageUpdateBloc,
                          builder: (context, redState) {
                            return (_checkWarningUseCase.isExtraLeakage) ? imageExtraLeakage : const Stack();
                          }),
                  ),
                  BlocProvider(
                    create: (context) => intraOsmosisWarningImageUpdateBloc,
                    child: BlocBuilder<UpdateBloc, UpdateState>(
                        bloc: intraOsmosisWarningImageUpdateBloc,
                        builder: (context, redState) {
                          return (_checkWarningUseCase.isIntraOsmosis) ? imageIntraOsmosis : const Stack();
                        }),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        widget = bleScanningView;
      }
    } else {
      widget = const BluetoothOffView();
    }
    return widget;
  }

  StreamSubscription<bool>? _onBLEDeviceConnection;
  setOnBLEDeviceConnection(BLEDevice device) {
    if(_onBLEDeviceConnection != null) {
      _onBLEDeviceConnection!.cancel();
    }
    _onBLEDeviceConnection = device.onConnectStateChange((isConnected) {
      bleRepositoryBloc.add(BLEUpdate());
    });
  }

  double widthExtraLeakageLineChart = 0;
  double heightExtraLeakageLineChart = 0;
  double widthIntraOsmosisLineChart = 0;
  double heightIntraOsmosisLineChart = 0;

  double get leftExtraLeakageLineChart => (widthExtraLeakageLineChart - warningImageSize) / 2;
  double get topExtraLeakageLineChart => (heightExtraLeakageLineChart - warningImageSize) / 2;
  double get leftIntraOsmosisLineChart => (widthIntraOsmosisLineChart - warningImageSize) / 2;
  double get topIntraOsmosisLineChart => heightExtraLeakageLineChart + (heightIntraOsmosisLineChart - warningImageSize) / 2 + AppTheme.heightDivider;

  @override
  void initState() {
    super.initState();
    stopWarning();
    _onExtraLeakage = _checkWarningUseCase.onExtraLeakage((isExtraLeakage) {
      if(previousIsExtraLeakage == isExtraLeakage) {
        return;
      }
      previousIsExtraLeakage = isExtraLeakage;
      if(isExtraLeakage) {
        startWarning();
      } else {
        stopWarning();
      }
      extraLeakageWarningImageUpdateBloc.add(const UpdateEvent());
    });
    _onIntraOsmosis = _checkWarningUseCase.onIntraOsmosis((isIntraOsmosis) {
      if(previousIsIntraOsmosis == isIntraOsmosis) {
        return;
      }
      previousIsIntraOsmosis = isIntraOsmosis;
      if(isIntraOsmosis) {
        startWarning();
      } else {
        stopWarning();
      }
      intraOsmosisWarningImageUpdateBloc.add(const UpdateEvent());
    });
    bleScanningView = BLEScanningView(
      bleRepositoryBloc: bleRepositoryBloc,
      scannedBLETile: (BLEDevice device) {
        return ScannedBLETile(
          bleDeviceBloc: BLEDeviceBloc(device),
          onConnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.addWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceConnect());
            setOnBLEDeviceConnection(device);
          },
          onDisconnect: (BLEDeviceBloc bleDeviceBloc) {
            bleSelectedAutoReconnectUseCase.removeWantedAutoConnect(device);
            bleDeviceBloc.add(BLEDeviceDisconnect());
            setOnBLEDeviceConnection(device);
          },
          colorConnected: AppTheme.bleConnectedColor,
          colorDisconnected: AppTheme.bleDisconnectedColor,
          textConnected: R.str.connect,
          textDisconnected: R.str.disconnect,
        );
      },
    );

    _extraLeakageLineChartView = BlocProvider(
        create: (context) => extraLeakageLineChartUpdateBloc,
        child: BlocBuilder<UpdateBloc, UpdateState>(
            bloc: extraLeakageLineChartUpdateBloc,
            builder: (context, redState) {
              return Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    widthExtraLeakageLineChart = constraints.maxWidth;
                    heightExtraLeakageLineChart = constraints.maxHeight;
                    // debugPrint("screenHeight: ${screenHeight(context)}");
                    // debugPrint("_extraLeakageLineChartView: $heightExtraLeakageLineChart");
                    return LineChartViewInfo(
                      updateBloc: extraLeakageLineChartUpdateBloc,
                      lineChartListenerBloc: extraLeakageLineChartListenerBloc,
                      data: extraLeakageLineChartUseCase.chartData,
                    );
                  },
                ),
              );
            },
        ),
    );

    _intraOsmosisLineChartView = BlocProvider(
        create: (context) => intraOsmosisLineChartUpdateBloc,
        child: BlocBuilder<UpdateBloc, UpdateState>(
            bloc: intraOsmosisLineChartUpdateBloc,
            builder: (context, redState) {
              return Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    widthIntraOsmosisLineChart = constraints.maxWidth;
                    heightIntraOsmosisLineChart = constraints.maxHeight;
                    return LineChartViewInfo(
                      updateBloc: intraOsmosisLineChartUpdateBloc,
                      lineChartListenerBloc: intraOsmosisLineChartListenerBloc,
                      data: intraOsmosisLineChartUseCase.chartData,
                    );
                  },
                ),
              );
            },
        ),
    );
    _onRepositoryUpdate = GlobalVariables.instance.leakageRepository.onAdd((row) {
      extraLeakageLineChartUpdateBloc.add(const UpdateEvent());
      intraOsmosisLineChartUpdateBloc.add(const UpdateEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    R.set(context);
    return BlocProvider(
      create: (context) => bleRepositoryBloc,
      child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
        bloc: bleRepositoryBloc,
        builder: (context, state) {
          return screen;
        }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    extraLeakageLineChartListenerBloc.add(LineChartEventDispose());
    intraOsmosisLineChartListenerBloc.add(LineChartEventDispose());
    _onRepositoryUpdate.cancel();
  }
}