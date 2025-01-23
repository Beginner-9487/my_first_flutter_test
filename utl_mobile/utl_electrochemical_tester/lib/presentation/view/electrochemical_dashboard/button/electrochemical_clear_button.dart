import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/resources/theme_data.dart';

class ElectrochemicalClearButton extends StatefulWidget {
  const ElectrochemicalClearButton({super.key});
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ElectrochemicalClearButton> {
  var electrochemicalFeatureController = ControllerRegistry.electrochemicalFeatureController;
  bool enabled = true;
  VoidCallback? onPressed(AppLocalizations appLocalizations) {
    if(enabled) {
      return () {
        setState(() {
          enabled = false;
          electrochemicalFeatureController
            .clearRepository()
            .then((value) {
              setState(() {
                enabled = true;
              });
            });
        });
      };
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return IconButton(
      onPressed: onPressed(appLocalizations),
      icon: Icon(Icons.clear),
      color: theme.clearEnabledColor,
    );
  }
}
