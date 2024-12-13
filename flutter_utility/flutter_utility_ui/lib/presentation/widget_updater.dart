import 'dart:async';

import 'package:flutter/material.dart';

class WidgetUpdater extends StatefulWidget {
  WidgetUpdater({
    super.key,
    required Widget widget,
  }) : _widget = widget {
    _controller = StreamController.broadcast();
    return;
  }

  Widget _widget;
  late final StreamController<void> _controller;
  late final StreamSubscription<void> _subscription;

  void update(Widget widget) {
    _widget = widget;
    _controller.add(null);
  }

  @override
  State<WidgetUpdater> createState() => _WidgetUpdaterState();
}

class _WidgetUpdaterState<View extends WidgetUpdater> extends State<View> {
  @override
  void initState() {
    super.initState();
    widget._subscription = widget._controller.stream.listen((data) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return widget._widget;
  }

  @override
  void dispose() {
    super.dispose();
    widget._subscription.cancel();
    widget._controller.close();
    return;
  }
}