import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ElectrochemicalFeatureController {
  Future<bool> downloadFile({
    required AppLocalizations appLocalizations,
  });
  Future<bool> clearRepository();
}
