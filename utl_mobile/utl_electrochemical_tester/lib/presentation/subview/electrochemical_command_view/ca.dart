import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/tab_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CaElectrochemicalCommandTabView extends ElectrochemicalCommandTabView {
  const CaElectrochemicalCommandTabView({
    super.key,
  });
  @override
  State<CaElectrochemicalCommandTabView> createState() => _State();
}

class _State extends ElectrochemicalCommandTabViewState<CaElectrochemicalCommandTabView> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  String get title => AppLocalizations.of(context)!.ca;
  static const String eDcKey = "CA_E_dc_key";
  static const String tIntervalKey = "CA_t_interval_key";
  static const String tRunKey = "CA_t_run_key";
  final TextEditingController eDcController = TextEditingController();
  final TextEditingController tIntervalController = TextEditingController();
  final TextEditingController tRunController = TextEditingController();
  @override
  void initState() {
    super.initState();
    eDcController.text = sharedPreferences.getString(eDcKey) ?? "";
    tIntervalController.text = sharedPreferences.getString(tIntervalKey) ?? "";
    tRunController.text = sharedPreferences.getString(tRunKey) ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(
          onPressed: onStartCa,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              ad5940HsRTiaRow,
              Divider(),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.eDc,
                controller: eDcController,
                onChanged: (value) => sharedPreferences.setString(eDcKey, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.tInterval,
                controller: tIntervalController,
                onChanged: (value) => sharedPreferences.setString(tIntervalKey, value),
              ),
              buildNumberInputField(
                label: AppLocalizations.of(context)!.tRun,
                controller: tRunController,
                onChanged: (value) => sharedPreferences.setString(tRunKey, value),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void onStartCa() {
    for (var device in electrochemicalCommandController.devices) {
      electrochemicalCommandController.setName(
        device,
        dataName,
      );
      electrochemicalCommandController.startCa(
        CaSentPacket(
          ad5940Parameters: ad5940Parameters,
          electrochemicalParameters: CaElectrochemicalParameters(
            eDc: (double.parse(eDcController.text) * 1000).toInt(),
            tInterval: (double.parse(tIntervalController.text) * 1000).toInt(),
            tRun: (double.parse(tRunController.text) * 1000).toInt(),
          ),
        ),
      );
    }
  }
}
