import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_widget_builder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

class ElectrochemicalCommandTypeView extends StatelessWidget {
  final ElectrochemicalType type;
  const ElectrochemicalCommandTypeView                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ({
    super.key,
    required this.type,
  });
  Widget buildCa(ElectrochemicalCommandController electrochemicalCommandController, AppLocalizations appLocalizations) {
    return Column(
      children: [
        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eDc,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCaElectrochemicalParametersEDc() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCaElectrochemicalParametersEDc((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tInterval,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCaElectrochemicalParametersTInterval() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCaElectrochemicalParametersTInterval((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tRun,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCaElectrochemicalParametersTRun() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCaElectrochemicalParametersTRun((double.parse(source) * 1000.0).toInt()),
          ),
        ),
      ],
    );
  }
  Widget buildCv(ElectrochemicalCommandController electrochemicalCommandController, AppLocalizations appLocalizations) {
    return Column(
      children: [
        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eBegin,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCvElectrochemicalParametersEBegin() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersEBegin((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eVertex1,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCvElectrochemicalParametersEVertex1() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersEVertex1((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eVertex2,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCvElectrochemicalParametersEVertex2() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersEVertex2((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eStep,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCvElectrochemicalParametersEStep() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersEStep((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.scanRate,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getCvElectrochemicalParametersScanRate() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersScanRate((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.numberOfScans,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersNumberOfScans().toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setCvElectrochemicalParametersNumberOfScans(int.parse(source)),
          ),
        ),
      ],
    );
  }
  Widget buildDpv(ElectrochemicalCommandController electrochemicalCommandController, AppLocalizations appLocalizations) {
    return Column(
      children: [
        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eBegin,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersEBegin() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersEBegin((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eEnd,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersEEnd() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersEEnd((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eStep,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersEStep() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersEStep((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.ePulse,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersEPulse() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersEPulse((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tPulse,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersTPulse() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersTPulse((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.scanRate,
          body: TextFormField(
            initialValue: (electrochemicalCommandController.getDpvElectrochemicalParametersScanRate() / 1000.0).toString(),
            keyboardType: TextInputType.number,
            onChanged: (source) => electrochemicalCommandController.setDpvElectrochemicalParametersScanRate((double.parse(source) * 1000.0).toInt()),
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.inversionOption,
          body: DropdownButton<DpvElectrochemicalParametersInversionOption>(
            value: electrochemicalCommandController.getDpvElectrochemicalParametersInversionOption(),
            onChanged: (newValue) => electrochemicalCommandController.setDpvElectrochemicalParametersInversionOption(newValue!),
            items: DpvElectrochemicalParametersInversionOption.values.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    var electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    var appLocalizations = AppLocalizations.of(context)!;
    switch (type) {
      case ElectrochemicalType.ca:
        return buildCa(electrochemicalCommandController, appLocalizations);
      case ElectrochemicalType.cv:
        return buildCv(electrochemicalCommandController, appLocalizations);
      case ElectrochemicalType.dpv:
        return buildDpv(electrochemicalCommandController, appLocalizations);
    }
  }
}
