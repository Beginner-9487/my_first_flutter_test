import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class R {
  static BuildContext? _context;
  static AppLocalizations? current = AppLocalizations.of(_context!);
  static AppLocalizations get str => current!;

  static set(BuildContext setContext) {
    _context = setContext;
  }

  static load(Locale locale) {
    AppLocalizations.delegate.load(locale);
  }

  static bool get isLightMode => (_context != null) ? MediaQuery.of(_context!).platformBrightness == Brightness.light : true;
}