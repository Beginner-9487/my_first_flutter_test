import 'dart:async';

abstract class SaveFileUseCase {
  startSavingFile();
  stopSavingFile();
  bool get isSavingFile;
  StreamSubscription<bool> onSavingFile(void Function(bool state) doSomething);
}