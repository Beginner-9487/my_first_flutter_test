import 'dart:async';

abstract class BackgroundProcessor {
  bool get isRunning;
  startBackgroundProcess();
  stopBackgroundProcess();
  StreamSubscription<bool> onRunningStateChange(void Function(bool state) doSomething);
}