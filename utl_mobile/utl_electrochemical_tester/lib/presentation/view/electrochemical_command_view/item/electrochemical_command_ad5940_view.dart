import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_widget_builder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

class ElectrochemicalCommandAd5940View extends StatelessWidget {
  const ElectrochemicalCommandAd5940View({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    final appLocalizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        ElectrochemicalCommandWidgetBuilder.buildTile(
          label: appLocalizations.ad5940ParametersElectrochemicalWorkingElectrode,
          body: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<Ad5940ParametersElectrochemicalWorkingElectrode>(
                value: electrochemicalCommandController.getAd5940ParametersElectrochemicalWorkingElectrode(),
                onChanged: (newValue) {
                  setState(() {
                    electrochemicalCommandController.setAd5940ParametersElectrochemicalWorkingElectrode(newValue!);
                  });
                },
                items: Ad5940ParametersElectrochemicalWorkingElectrode.values.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option.name),
                  );
                }).toList(),
              );
            },
          ),
        ),
        // ElectrochemicalCommandWidgetBuilder.buildTile(
        //   label: appLocalizations.ad5940HsRTia,
        //   body: StatefulBuilder(
        //     builder: (context, setState) {
        //       return DropdownButton<Ad5940ParametersHsTiaRTia>(
        //         value: electrochemicalCommandController.getAd5940ParametersHsTiaRTia(),
        //         onChanged: (newValue) {
        //           setState(() {
        //             electrochemicalCommandController.setAd5940ParametersHsTiaRTia(newValue!);
        //           });
        //         },
        //         items: Ad5940ParametersHsTiaRTia.values.map((option) {
        //           return DropdownMenuItem(
        //             value: option,
        //             child: Text(option.name),
        //           );
        //         }).toList(),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
