import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Localization',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Rebuilding MyHomePage");
    } // 測試 MyHomePage 是否被重建

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)!.title);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                return Text(AppLocalizations.of(context)!.welcomeMessage);
              },
            ),
            NonLocalizedButton(), // 不依賴 localizations
          ],
        ),
      ),
    );
  }
}

class NonLocalizedButton extends StatelessWidget {
  const NonLocalizedButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Building NonLocalizedButton");
    } // 測試是否重建
    return ElevatedButton(
      onPressed: () {
        if (kDebugMode) {
          print("Button pressed!");
        }
      },
      child: Text("Static Button"),
    );
  }
}
