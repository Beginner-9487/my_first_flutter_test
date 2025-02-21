import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:utl_amulet/controller/amulet_buttons_board_controller.dart';
import 'package:utl_amulet/init/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/presentation/theme/theme_data.dart';

class AmuletButtonsBoard extends StatelessWidget {
  const AmuletButtonsBoard({super.key});
  @override
  Widget build(BuildContext context) {
    final amuletButtonsBoardController = ControllerRegistry.amuletButtonsBoardController;
    return ChangeNotifierProvider<AmuletButtonsBoardIsSavingChangeNotifier>(
      create: (_) => amuletButtonsBoardController.createIsSavingChangeNotifier(),
      child: Consumer<AmuletButtonsBoardIsSavingChangeNotifier>(
        builder: (context, seriesListNotifier, child) {
          final toggleSavingButton = Consumer<AmuletButtonsBoardIsSavingChangeNotifier>(
            builder: (context, isSavingNotifier, child) {
              final isSaving = isSavingNotifier.isSaving;
              VoidCallback? onPressed = amuletButtonsBoardController.toggleSavingStage;
              final themeData = Theme.of(context);
              final color = (isSaving)
                  ? themeData.savingEnabledColor
                  : null;
              final iconData = (isSaving)
                  ? Icons.stop
                  : Icons.play_arrow;
              return IconButton(
                onPressed: onPressed,
                icon: Icon(
                  iconData,
                ),
                color: color,
              );
            },
          );
          bool isDownloadingFile = false;
          final downloadFileButton = StatefulBuilder(
            builder: (context, setState) {
              final appLocalizations = AppLocalizations.of(context)!;
              final themeData = Theme.of(context);
              VoidCallback? onPressed = (isDownloadingFile)
                ? null
                : () async {
                  setState(() {
                    isDownloadingFile = true;
                  });
                  await amuletButtonsBoardController.downloadFile(appLocalizations: appLocalizations);
                  setState(() {
                    isDownloadingFile = false;
                  });
                  Fluttertoast.showToast(
                    msg: appLocalizations.downloadFileFinishedNotification("csv"),
                  );
                };
              return IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.file_download,
                ),
                color: themeData.downloadEnabledColor,
              );
            },
          );
          final clearButtonButton = Builder(
            builder: (context) {
              final themeData = Theme.of(context);
              VoidCallback onPressed = amuletButtonsBoardController.clearBuffer;
              return IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.delete,
                ),
                color: themeData.clearEnabledColor,
              );
            }
          );
          return Column(
            children: [
              toggleSavingButton,
              downloadFileButton,
              clearButtonButton,
            ],
          );
        },
      ),
    );
  }
}
