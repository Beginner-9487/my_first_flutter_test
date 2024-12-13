import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothEnableView extends StatefulWidget {
  const BluetoothEnableView({
    super.key,
    required this.enableScreen,
    required this.disableScreen,
    required this.isEnable,
    required this.onEnable,
  });
  final Widget enableScreen;
  final Widget disableScreen;
  final bool Function() isEnable;
  final Stream<bool> onEnable;

  @override
  State createState() => _BluetoothEnableViewState();
}

class _BluetoothEnableViewState extends State<BluetoothEnableView> with WidgetsBindingObserver {
  Locale? _currentLocale;
  late final StreamSubscription<bool> _onEnable;

  @override
  void initState() {
    super.initState();
    _onEnable = widget.onEnable.listen((isLock) {
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);
    _currentLocale = View.of(context).platformDispatcher.locale;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales != null && locales.isNotEmpty) {
      final newLocale = locales.first;
      if (_currentLocale != newLocale) {
        setState(() {
          _currentLocale = newLocale;
        });
      }
    }
  }

  @override
  void dispose() {
    _onEnable.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isEnable()) ? widget.enableScreen : widget.disableScreen;
  }
}
