import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor_impl_fft.dart';
import 'package:flutter_background_processor/application/use_cases/background_work_use_case.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/presentation/bloc/repository/ble_repository_bloc.dart';
import 'package:flutter_ble/presentation/view/ble_scanning_view.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

late BLERepository bleRepository;
late BackgroundProcessor backgroundProcessor;

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(BLETaskHandler());
  debugPrint("startCallback");
}

void main() {
  bleRepository = BLERepositoryImplFBP.getInstance();
  backgroundProcessor = BackgroundProcessorImplFFT.init(
    startCallback: startCallback,
    androidNotificationOptions: AndroidNotificationOptions(
        channelId: "BLE channelId",
        channelName: "BLE channelName",
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      isOnceEvent: false,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BLERepositoryBloc bleRepositoryBloc;
  late BackgroundProcessUseCase backgroundProcessorUseCase;

  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    bleRepositoryBloc = BLERepositoryBloc(bleRepository);
    backgroundProcessorUseCase = BackgroundProcessUseCase(backgroundProcessor);
  }

  @override
  Widget build(BuildContext context) {
    backgroundProcessorUseCase.startBackgroundProcess();
    streamSubscription = bleRepository.onAllDevicesFounded((results) async {
      await FlutterForegroundTask.saveData(key: 'bleDeviceLength', value: bleRepository.allDevices.length);
    });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BLEScanningView(bleRepositoryBloc: bleRepositoryBloc);
    // return const Scaffold();
  }
}

class BLETaskHandler extends TaskHandler {
  SendPort? _sendPort;

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {
    debugPrint('BLETaskHandler.onDestroy');
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    FlutterForegroundTask.updateService(
      notificationTitle: 'BLETaskHandler',
      notificationText: 'device length: ${bleRepository.allDevices.length}',
    );
    // Send data to the main isolate.
    sendPort?.send(bleRepository.allDevices.length);
  }

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) {
    _sendPort = sendPort;
  }

  @override
  void onNotificationPressed() async {
    _sendPort?.send('onNotificationPressed');
    debugPrint("BLETaskHandler.onNotificationPressed: ${(await FlutterForegroundTask.getData<int>(key: 'bleDeviceLength'))}");
  }
}