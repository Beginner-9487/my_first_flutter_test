import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextResource on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);
  @override
  AppLocalizations? get appLocalizations => AppLocalizations.of(this);
  @override
  bool get isLightMode => mediaQueryData.platformBrightness == Brightness.light;
  @override
  double get screenHeight => mediaQueryData.size.height;
  @override
  double get screenWidth => mediaQueryData.size.width;
  @override
  double get screenAspectRatio => mediaQueryData.size.aspectRatio;
  @override
  double get screenDensity => mediaQueryData.devicePixelRatio;
  @override
  double get appBarHeight => kToolbarHeight;
  @override
  Locale get locale => View.of(this).platformDispatcher.locale;
}
