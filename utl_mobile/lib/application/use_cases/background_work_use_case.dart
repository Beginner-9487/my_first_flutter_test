import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';

class BackgroundWorkUseCase {
  BackgroundProcessor backgroundProcessor;
  BackgroundWorkUseCase(this.backgroundProcessor);
  bool get isRunning => backgroundProcessor.isRunning;
  startBackgroundWork() {backgroundProcessor.startBackgroundProcess();}
  stopBackgroundWork() {backgroundProcessor.stopBackgroundProcess();}
}