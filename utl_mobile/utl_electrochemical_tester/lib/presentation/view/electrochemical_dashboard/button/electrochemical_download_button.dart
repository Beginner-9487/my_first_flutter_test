import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/presentation/theme/theme_data.dart';

class ElectrochemicalDownloadButton extends StatelessWidget {
  const ElectrochemicalDownloadButton({super.key});
  @override
  Widget build(BuildContext context) {
    var electrochemicalFeatureController = ControllerRegistry.electrochemicalFeatureController;
    bool enabled = true;
    return StatefulBuilder(
      builder: (context, setState) {
        final appLocalizations = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        VoidCallback? onPressed = (enabled)
          ? () => setState(() {
            enabled = false;
            electrochemicalFeatureController
                .downloadFile(appLocalizations: appLocalizations)
                .then((value) {
              setState(() {
                Fluttertoast.showToast(
                  msg: appLocalizations.downloadFileFinishedNotification("csv"),
                );
                enabled = true;
              });
            });
          })
          : null;
        return IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.save),
          color: theme.downloadEnabledColor,
        );
      },
    );
  }
}
