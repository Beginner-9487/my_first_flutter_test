import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_widget_builder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

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
            initialValue: electrochemicalCommandController.getCaElectrochemicalParametersEDc(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCaElectrochemicalParametersEDc,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tInterval,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCaElectrochemicalParametersTInterval(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCaElectrochemicalParametersTInterval,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tRun,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCaElectrochemicalParametersTRun(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCaElectrochemicalParametersTRun,
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
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersEBegin(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersEBegin,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eVertex1,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersEVertex1(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersEVertex1,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eVertex2,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersEVertex2(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersEVertex2,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eStep,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersEStep(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersEStep,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.scanRate,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersScanRate(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersScanRate,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.numberOfScans,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getCvElectrochemicalParametersNumberOfScans(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setCvElectrochemicalParametersNumberOfScans,
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
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersEBegin(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersEBegin,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eEnd,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersEEnd(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersEEnd,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.eStep,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersEStep(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersEStep,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.ePulse,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersEPulse(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersEPulse,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.tPulse,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersTPulse(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersTPulse,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.scanRate,
          body: TextFormField(
            initialValue: electrochemicalCommandController.getDpvElectrochemicalParametersScanRate(),
            keyboardType: TextInputType.number,
            onChanged: electrochemicalCommandController.setDpvElectrochemicalParametersScanRate,
          ),
        ),

        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.inversionOption,
          body: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<DpvElectrochemicalParametersInversionOption>(
                value: electrochemicalCommandController.getDpvElectrochemicalParametersInversionOption(),
                onChanged: (newValue) {
                  setState(() {
                    electrochemicalCommandController.setDpvElectrochemicalParametersInversionOption(newValue!);
                  });
                },
                items: DpvElectrochemicalParametersInversionOption.values.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option.name),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    final appLocalizations = AppLocalizations.of(context)!;
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
