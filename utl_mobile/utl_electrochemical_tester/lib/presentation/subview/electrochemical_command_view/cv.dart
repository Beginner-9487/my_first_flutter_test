import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/tab_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CvElectrochemicalCommandTabView extends ElectrochemicalCommandTabView {
  const CvElectrochemicalCommandTabView({
    super.key,
  });
  @override
  State<CvElectrochemicalCommandTabView> createState() => _State();
}

class _State extends ElectrochemicalCommandTabViewState<CvElectrochemicalCommandTabView> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  String get title => AppLocalizations.of(context)!.cv;
  static const String eBeginKey = "CV_E_begin_key";
  static const String eVertex1Key = "CV_E_vertex1_key";
  static const String eVertex2Key = "CV_E_vertex2_key";
  static const String eStepKey = "CV_E_step_key";
  static const String scanRateKey = "CV_scan_rate_key";
  static const String numberOfScansKey = "CV_number_of_scans_key";
  final TextEditingController eBeginController = TextEditingController();
  final TextEditingController eVertex1Controller = TextEditingController();
  final TextEditingController eVertex2Controller = TextEditingController();
  final TextEditingController eStepController = TextEditingController();
  final TextEditingController scanRateController = TextEditingController();
  final TextEditingController numberOfScansController = TextEditingController();
  @override
  void initState() {
    super.initState();
    eBeginController.text = sharedPreferences.getString(eBeginKey) ?? "";
    eVertex1Controller.text = sharedPreferences.getString(eVertex1Key) ?? "";
    eVertex2Controller.text = sharedPreferences.getString(eVertex2Key) ?? "";
    eStepController.text = sharedPreferences.getString(eStepKey) ?? "";
    scanRateController.text = sharedPreferences.getString(scanRateKey) ?? "";
    numberOfScansController.text = sharedPreferences.getString(numberOfScansKey) ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(
          onPressed: onStartCv,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              ad5940HsRTiaRow,
              Divider(),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.eBegin,
                controller: eBeginController,
                onChanged: (value) => sharedPreferences.setString(eBeginKey, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.eVertex1,
                controller: eVertex1Controller,
                onChanged: (value) => sharedPreferences.setString(eVertex1Key, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.eVertex2,
                controller: eVertex2Controller,
                onChanged: (value) => sharedPreferences.setString(eVertex2Key, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.eStep,
                controller: eStepController,
                onChanged: (value) => sharedPreferences.setString(eStepKey, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.scanRate,
                controller: scanRateController,
                onChanged: (value) => sharedPreferences.setString(scanRateKey, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.numberOfScans,
                controller: numberOfScansController,
                onChanged: (value) => sharedPreferences.setString(numberOfScansKey, value),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void onStartCv() {
    for (var device in electrochemicalCommandController.devices) {
      electrochemicalCommandController.setName(
        device,
        dataName,
      );
      electrochemicalCommandController.startCv(
        CvSentPacket(
          ad5940Parameters: ad5940Parameters,
          electrochemicalParameters: CvElectrochemicalParameters(
            eBegin: (double.parse(eBeginController.text) * 1000).toInt(),
            eVertex1: (double.parse(eVertex1Controller.text) * 1000).toInt(),
            eVertex2: (double.parse(eVertex2Controller.text) * 1000).toInt(),
            eStep: (double.parse(eStepController.text) * 1000).toInt(),
            scanRate: (double.parse(scanRateController.text) * 1000).toInt(),
            numberOfScans: int.parse(numberOfScansController.text),
          ),
        ),
      );
    }
  }
}