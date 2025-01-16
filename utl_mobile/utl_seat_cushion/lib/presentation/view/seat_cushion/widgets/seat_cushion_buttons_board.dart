import 'package:flutter/material.dart';
import 'package:flutter_basic_utils/presentation/language_observer_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:utl_seat_cushion/application/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/resources/application_resources.dart';
import 'package:utl_seat_cushion/resources/path_resources.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_seat_cushion/resources/widget_resources.dart';

class SeatCushionButtonsBoard extends StatefulWidget {
  const SeatCushionButtonsBoard({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _SeatCushionButtonsBoardState();
}

class _SeatCushionButtonsBoardState extends State<SeatCushionButtonsBoard> {
  final TextEditingController commandTextFieldController = TextEditingController();
  final ValueNotifier<bool> downloadingCsvFileButtonStateValueNotifier = ValueNotifier(true);
  final ValueNotifier<bool> clearOldDataButtonStateValueNotifier = ValueNotifier(true);
  final SeatCushionDataViewController seatCushionDataViewController = ApplicationResources.seatCushionDataViewController;
  @override
  Widget build(BuildContext context) {
    var commandTextField = TextField(
      controller: commandTextFieldController,
    );
    var initButton = IconButton(
      onPressed: null,
      icon: WidgetResources.bluetoothInitIcon,
      color: Colors.blue,
    );
    var sendCommandButton = IconButton(
      onPressed: () {
        String command = commandTextFieldController.text;
        seatCushionDataViewController.sendCommand(command: command);
        commandTextFieldController.text = "";
      },
      icon: WidgetResources.bluetoothSendCommandIcon,
      color: Colors.blue,
    );
    var saveStateChangeButton = StreamBuilder(
      initialData: seatCushionDataViewController.isSaving,
      stream: seatCushionDataViewController.isSavingStream,
      builder: (context, snapshot) {
        bool isSaving = (snapshot.data ?? seatCushionDataViewController.isSaving);
        return IconButton(
          onPressed: seatCushionDataViewController.toggleSavingState,
          icon: (!isSaving)
            ? WidgetResources.startSavingIcon
            : WidgetResources.endSavingIcon,
          color: (!isSaving)
            ? null
            : Colors.orange,
        );
      },
    );
    var clearOldDataButton = ValueListenableBuilder(
      valueListenable: clearOldDataButtonStateValueNotifier,
      builder: (context, isEnabled, child) {
        return LanguageObserverView(
          builder: (context, locales) {
            var appLocalizations = AppLocalizations.of(context)!;
            return IconButton(
              onPressed: (isEnabled)
                ? () async {
                    clearOldDataButtonStateValueNotifier.value = false;
                    await seatCushionDataViewController.clearOldData();
                    try {
                      clearOldDataButtonStateValueNotifier.value = true;
                    } catch(e) {}
                    Fluttertoast.showToast(
                      msg: appLocalizations.clearOldDataNotification,
                    );
                    return;
                  }
                : null,
              icon: WidgetResources.clearOldDataIcon,
              color: Colors.red,
            );
          },
        );
      },
    );
    var downloadCsvFileButton = ValueListenableBuilder(
      valueListenable: downloadingCsvFileButtonStateValueNotifier,
      builder: (context, isEnabled, child) {
        return LanguageObserverView(
          builder: (context, locales) {
            var appLocalizations = AppLocalizations.of(context)!;
            return IconButton(
              onPressed: (isEnabled)
                ? () async {
                    downloadingCsvFileButtonStateValueNotifier.value = false;
                    await seatCushionDataViewController.downloadCsvFile(
                      folder: PathResources.downloadPath,
                      appLocalizations: appLocalizations,
                    );
                    try {
                      downloadingCsvFileButtonStateValueNotifier.value = true;
                    } catch(e) {}
                    Fluttertoast.showToast(
                      msg: appLocalizations.downloadFileFinishedNotification("csv"),
                    );
                    return;
                  }
                : null,
              icon: WidgetResources.downloadIcon,
              color: Colors.green,
            );
          },
        );
      },
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: commandTextField,
            ),
            sendCommandButton,
            initButton,
          ],
        ),
        Row(
          children: [
            clearOldDataButton,
            Spacer(),
            saveStateChangeButton,
            downloadCsvFileButton,
          ],
        ),
      ],
    );
  }
  @override
  void dispose() {
    commandTextFieldController.dispose();
    downloadingCsvFileButtonStateValueNotifier.dispose();
    clearOldDataButtonStateValueNotifier.dispose();
    super.dispose();
  }
}