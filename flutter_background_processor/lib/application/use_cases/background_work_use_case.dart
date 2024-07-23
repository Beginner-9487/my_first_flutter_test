import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';

class BackgroundProcessUseCase {
  BackgroundProcessor backgroundProcessor;
  BackgroundProcessUseCase(this.backgroundProcessor);
  bool get isRunning => backgroundProcessor.isRunning;
  startBackgroundProcess() {backgroundProcessor.startBackgroundProcess();}
  stopBackgroundProcess() {backgroundProcessor.stopBackgroundProcess();}
}