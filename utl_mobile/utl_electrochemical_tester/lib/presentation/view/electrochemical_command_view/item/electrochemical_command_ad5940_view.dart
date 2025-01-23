import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/adapter/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_widget_builder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

class ElectrochemicalCommandAd5940View extends StatelessWidget {
  const ElectrochemicalCommandAd5940View({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    var appLocalizations = AppLocalizations.of(context)!;
    return ElectrochemicalCommandWidgetBuilder.buildTile(
      label: appLocalizations.ad5940HsRTia,
      body: DropdownButton<Ad5940ParametersHsTiaRTia>(
        value: electrochemicalCommandController.getAd5940ParametersHsTiaRTia(),
        onChanged: (newValue) => electrochemicalCommandController.setAd5940ParametersHsTiaRTia(newValue!),
        items: Ad5940ParametersHsTiaRTia.values.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option.name),
          );
        }).toList(),
      ),
    );
  }
}
