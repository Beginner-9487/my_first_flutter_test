import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AmuletButtonsBoardIsSavingChangeNotifier extends ChangeNotifier {
  bool get isSaving;
}

abstract class AmuletButtonsBoardController {
  AmuletButtonsBoardIsSavingChangeNotifier createIsSavingChangeNotifier();
  void toggleSavingStage();
  Future<bool> downloadFile({
    required AppLocalizations appLocalizations,
  });
  void clearBuffer();
}
