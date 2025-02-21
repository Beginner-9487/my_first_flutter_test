import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/init/initializer.dart';
import 'package:utl_electrochemical_tester/presentation/screen/home_screen.dart';
import 'package:utl_mobile/theme/theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Initializer initializer = ConcreteInitializer();
  await initializer();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      color: themeData.screenBackgroundColor,
      home: const HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
