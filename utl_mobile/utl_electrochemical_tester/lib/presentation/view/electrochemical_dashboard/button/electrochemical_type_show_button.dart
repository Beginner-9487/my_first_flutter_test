import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

import 'package:utl_electrochemical_tester/presentation/theme/theme_data.dart';

class ElectrochemicalTypeShowButton extends StatelessWidget {
  final ElectrochemicalType type;
  const ElectrochemicalTypeShowButton({
    super.key,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    var electrochemicalLineChartSetterController = ControllerRegistry.electrochemicalLineChartSetterController;
    return ChangeNotifierProvider<LineChartTypesShowChangeNotifier>(
      create: electrochemicalLineChartSetterController.createLineChartTypesShowChangeNotifier,
      child: Consumer<LineChartTypesShowChangeNotifier>(
        builder: (context, typeShowNotifier, child) {
          final theme = Theme.of(context);
          final entry = typeShowNotifier.shows.entries.where((entry) => entry.key == type).first;
          int index = type.index;
          final iconData = ElectrochemicalIcons.typeIconData.skip(index).first;
          bool show = entry.value;
          Color? color = (show)
              ? theme.lineChartTypeEnabledColor
              : null;
          return IconButton(
            onPressed: () {
              electrochemicalLineChartSetterController.setTypeShow(
                type: type,
                show: !show,
              );
            },
            icon: Icon(iconData),
            color: color,
          );
        },
      ),
    );
  }
}
