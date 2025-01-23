import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

class ElectrochemicalCommandHeaderView extends StatelessWidget {
  final ElectrochemicalType type;
  const ElectrochemicalCommandHeaderView({
    super.key,
    required this.type,
  });
  String getTitle(AppLocalizations appLocalizations) {
    switch (type) {
      case ElectrochemicalType.ca:
        return appLocalizations.ca;
      case ElectrochemicalType.cv:
        return appLocalizations.cv;
      case ElectrochemicalType.dpv:
        return appLocalizations.dpv;
    }
  }
  @override
  Widget build(BuildContext context) {
    var electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    var appLocalizations = AppLocalizations.of(context)!;
    var title = getTitle(appLocalizations);
    return ListTile(
      leading: Text(title),
      title: Expanded(
        child: TextFormField(
          initialValue: electrochemicalCommandController.getDataNameBuffer(),
          onChanged: electrochemicalCommandController.setDataNameBuffer,
        ),
      ),
      trailing: IconButton(
        onPressed: () => electrochemicalCommandController.start(type: type),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
