import 'package:flutter/material.dart';

class LanguageObserverView extends StatefulWidget {
  LanguageObserverView({
    super.key,
    required this.builder,
  });
  final Widget Function(BuildContext context, Iterable<Locale> locales) builder;
  List<Locale>? _locales;
  Iterable<Locale> get locales => _locales ?? [];
  @override
  State<LanguageObserverView> createState() => _LanguageObserverViewState();
}

class _LanguageObserverViewState extends State<LanguageObserverView> with WidgetsBindingObserver {
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    final Locale? oldLocal = widget._locales?.firstOrNull;
    final Locale? newLocale = locales?.firstOrNull;
    widget._locales = locales;
    if (oldLocal != newLocale) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.locales,
    );
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}