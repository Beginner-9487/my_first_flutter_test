import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/tab_view.dart';

class DpvElectrochemicalCommandTabView extends ElectrochemicalCommandTabView {
  const DpvElectrochemicalCommandTabView({
    super.key,
  });
  @override
  State<DpvElectrochemicalCommandTabView> createState() => _State();
}

class _State extends ElectrochemicalCommandTabViewState<DpvElectrochemicalCommandTabView> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  String get title => context.appLocalizations!.dpv;
  static const String eBeginKey = "DPV_E_begin_key";
  static const String eEndKey = "DPV_E_end_key";
  static const String eStepKey = "DPV_E_step_key";
  static const String ePulseKey = "DPV_E_pulse_key";
  static const String tPulseKey = "DPV_t_pulse_key";
  static const String scanRateKey = "DPV_scan_rate_key";
  static const String inversionOptionKey = "dpvInversionOptionKey";
  final TextEditingController eBeginController = TextEditingController();
  final TextEditingController eEndController = TextEditingController();
  final TextEditingController eStepController = TextEditingController();
  final TextEditingController ePulseController = TextEditingController();
  final TextEditingController tPulseController = TextEditingController();
  final TextEditingController scanRateController = TextEditingController();
  int inversionOptionValue = 0;
  @override
  void initState() {
    super.initState();
    eBeginController.text = sharedPreferences.getString(eBeginKey) ?? "";
    eEndController.text = sharedPreferences.getString(eEndKey) ?? "";
    eStepController.text = sharedPreferences.getString(eStepKey) ?? "";
    ePulseController.text = sharedPreferences.getString(ePulseKey) ?? "";
    tPulseController.text = sharedPreferences.getString(tPulseKey) ?? "";
    scanRateController.text = sharedPreferences.getString(scanRateKey) ?? "";
    inversionOptionValue = InversionOption.values[sharedPreferences.getInt(inversionOptionKey) ?? 0].index;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(
          onPressed: onStartDpv,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              ad5940HsRTiaRow,
              Divider(),
              buildNumberInputField(
                label: context.appLocalizations!.eBegin,
                controller: eBeginController,
                onChanged: (value) => sharedPreferences.setString(eBeginKey, value),
              ),
              buildNumberInputField(
                label: context.appLocalizations!.eEnd,
                controller: eEndController,
                onChanged: (value) => sharedPreferences.setString(eEndKey, value),
              ),
              buildNumberInputField(
                label: context.appLocalizations!.eStep,
                controller: eStepController,
                onChanged: (value) => sharedPreferences.setString(eStepKey, value),
              ),
              buildNumberInputField(
                label: context.appLocalizations!.ePulse,
                controller: ePulseController,
                onChanged: (value) => sharedPreferences.setString(ePulseKey, value),
              ),
              buildNumberInputField(
                label: context.appLocalizations!.tPulse,
                controller: tPulseController,
                onChanged: (value) => sharedPreferences.setString(tPulseKey, value),
              ),
              buildNumberInputField(
                label: context.appLocalizations!.scanRate,
                controller: scanRateController,
                onChanged: (value) => sharedPreferences.setString(scanRateKey, value),
              ),
              buildDropdownMenu(
                label: context.appLocalizations!.inversionOption,
                initialSelection: inversionOptionValue,
                onSelected: (int? value) {
                  inversionOptionValue = value ?? inversionOptionValue;
                  sharedPreferences.setInt(inversionOptionKey, inversionOptionValue);
                },
                dropdownMenuEntries: InversionOption.values.map((option) => DropdownMenuEntry(
                  value: option.index,
                  label: option.name,
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void onStartDpv() {
    for (var device in electrochemicalCommandController.devices) {
      electrochemicalCommandController.setName(
        device,
        dataName,
      );
      electrochemicalCommandController.startDpv(
        DpvSentPacket(
          ad5940Parameters: ad5940Parameters,
          electrochemicalParameters: DpvElectrochemicalParameters(
            eBegin: (double.parse(eBeginController.text) * 1000).toInt(),
            eEnd: (double.parse(eEndController.text) * 1000).toInt(),
            eStep: (double.parse(eStepController.text) * 1000).toInt(),
            ePulse: (double.parse(ePulseController.text) * 1000).toInt(),
            tPulse: (double.parse(tPulseController.text) * 1000).toInt(),
            scanRate: (double.parse(scanRateController.text) * 1000).toInt(),
            inversionOption: InversionOption.values[inversionOptionValue],
          ),
        ),
      );
    }
  }
}
