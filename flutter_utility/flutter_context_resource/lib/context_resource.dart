import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ContextResourceProvider {
  Iterable<ContextResource> get contexts;
  ContextResource get(BuildContext context);
  void add(BuildContext context);
  void remove(BuildContext context);
  void load(Locale locale);
}

abstract class ContextResource {
  BuildContext get context;
  void setContext(BuildContext context);
  AppLocalizations get str;
  bool get isLightMode;
  double get screenHeight;
  double get screenWidth;
  double get screenAspectRatio;
  double get screenDensity;
  double get appBarHeight;
}