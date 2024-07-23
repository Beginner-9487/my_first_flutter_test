import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

late void Function() _startCallback;

class BackgroundProcessorImplFFT implements BackgroundProcessor {
  static TaskHandler? _taskHandler;

  @override
  bool isRunning = false;

  late StreamController<bool> _onRunningStateChange;

  AndroidNotificationOptions? _androidNotificationOptions;
  IOSNotificationOptions? _iosNotificationOptions;
  ForegroundTaskOptions? _foregroundTaskOptions;

  BackgroundProcessorImplFFT._() {
    _onRunningStateChange = StreamController.broadcast();
  }
  static BackgroundProcessorImplFFT? instance;
  static BackgroundProcessorImplFFT init({
    void Function()? startCallback,
    AndroidNotificationOptions? androidNotificationOptions,
    IOSNotificationOptions? iosNotificationOptions,
    ForegroundTaskOptions? foregroundTaskOptions,
  }) {
    instance ??= BackgroundProcessorImplFFT._();
    if(startCallback != null) {
      _startCallback = startCallback;
    }
    instance!._androidNotificationOptions = androidNotificationOptions;
    instance!._iosNotificationOptions = iosNotificationOptions;
    instance!._foregroundTaskOptions = foregroundTaskOptions;
    return instance!;
  }

  ReceivePort? _receivePort;

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    if(_androidNotificationOptions == null) {return;}
    if(_iosNotificationOptions == null) {return;}
    if(_foregroundTaskOptions == null) {return;}
    FlutterForegroundTask.init(
      androidNotificationOptions: _androidNotificationOptions!,
      iosNotificationOptions: _iosNotificationOptions!,
      foregroundTaskOptions: _foregroundTaskOptions!,
    );
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }
    _closeReceivePort();
    _receivePort = newReceivePort;
    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  _beforeStarting() async {
    _initForegroundTask();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();

      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
    isReadyToStart = true;
  }

  bool isReadyToStart = false;

  @override
  startBackgroundProcess() async {
    if(!isReadyToStart) {
      await _beforeStarting();
    }

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      debugPrint('Failed to register receivePort!');
      return false;
    }

    bool success = false;
    if (await FlutterForegroundTask.isRunningService) {
      success = await FlutterForegroundTask.restartService();
    } else {
      success = await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: _startCallback,
      );
    }
    if(success) {
      isRunning = true;
      _onRunningStateChange.sink.add(isRunning);
    }
    return success;
  }

  @override
  stopBackgroundProcess() async {
    _closeReceivePort();
    isRunning = false;
    _onRunningStateChange.sink.add(isRunning);
  }

  @override
  StreamSubscription<bool> onRunningStateChange(void Function(bool state) doSomething) {
    return _onRunningStateChange.stream.listen(doSomething);
  }
}