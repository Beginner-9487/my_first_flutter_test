import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContextResourceProviderImpl implements ContextResourceProvider {
  static ContextResourceProviderImpl? _instance;
  static ContextResourceProviderImpl getInstance() {
    _instance ??= ContextResourceProviderImpl._();
    return _instance!;
  }
  ContextResourceProviderImpl._();
  @override
  List<ContextResource> contexts = [];

  @override
  ContextResource get(BuildContext context) {
    ContextResource? resource = contexts
        .where((element) => element.context == context)
        .firstOrNull;
    if(resource == null) {
      resource = ContextResourceImpl(context);
      contexts.add(resource);
    }
    return resource;
  }

  @override
  add(BuildContext context) {
    remove(context);
    contexts.add(ContextResourceImpl(context));
  }
  @override
  remove(BuildContext context) {
    contexts.remove(contexts
      .where((element) => element.context == context)
      .firstOrNull
    );
  }
  @override
  load(Locale locale) {
    AppLocalizations.delegate.load(locale);
  }
}

class ContextResourceImpl implements ContextResource {
  MediaQueryData get mediaQueryData => MediaQuery.of(context);
  ContextResourceImpl(this.context);
  @override
  BuildContext context;
  @override
  void setContext(BuildContext context) {
    this.context = context;
  }
  @override
  AppLocalizations get str => AppLocalizations.of(context)!;
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
}