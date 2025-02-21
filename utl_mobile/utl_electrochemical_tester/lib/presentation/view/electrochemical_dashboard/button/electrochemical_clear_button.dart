import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';
import 'package:utl_electrochemical_tester/presentation/theme/theme_data.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ElectrochemicalClearButton extends StatelessWidget {
  const ElectrochemicalClearButton({super.key});
  @override
  Widget build(BuildContext context) {
    var electrochemicalFeatureController = ControllerRegistry.electrochemicalFeatureController;
    bool enabled = true;
    return StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        final appLocalizations = AppLocalizations.of(context)!;
        dialogOnPressed() => setState(() {
          enabled = false;
          electrochemicalFeatureController
              .clearRepository()
              .then((value) {
            setState(() {
              enabled = true;
            });
          });
        });
        final clearCheckDialog = AlertDialog(
          title: Text(appLocalizations.clearAllDataTitle),
          content: Text(appLocalizations.areYouSureYouWantToClearAllDataMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                dialogOnPressed();
              },
              child: Text(appLocalizations.yesButtonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 在這裡執行確認後的操作
              },
              child: Text(appLocalizations.noButtonText),
            ),
          ],
        );
        VoidCallback? onPressed = (enabled)
          ? () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return clearCheckDialog;
            },
          )
          : null;
        return IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.delete),
          color: theme.clearEnabledColor,
        );
      },
    );
  }
}
