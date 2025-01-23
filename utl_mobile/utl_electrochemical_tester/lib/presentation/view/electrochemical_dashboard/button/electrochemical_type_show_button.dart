import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

import 'package:utl_electrochemical_tester/resources/theme_data.dart';

class ElectrochemicalTypeShowButton extends StatelessWidget {
  final ElectrochemicalType type;
  const ElectrochemicalTypeShowButton({
    super.key,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    var electrochemicalLineChartSetterController = ControllerRegistry.electrochemicalLineChartSetterController;
    return ChangeNotifierProvider<LineChartDatasetTypesShowChangeNotifier>(
      create: (_) => electrochemicalLineChartSetterController.lineChartTypesShow,
      child: Consumer<LineChartDatasetTypesShowChangeNotifier>(
        builder: (context, typeShowNotifier, child) {
          var theme = Theme.of(context);
          var entry = typeShowNotifier.shows.entries.where((entry) => entry.key == type).first;
          int index = type.index;
          bool show = entry.value;
          Color? color = (show)
              ? theme.lineChartModeEnabledColor
              : null;
          return IconButton(
            onPressed: () {
              electrochemicalLineChartSetterController.setTypeShow(
                type: type,
                show: !show,
              );
            },
            icon: ElectrochemicalIcons.typeIcons.skip(index).first,
            color: color,
          );
        },
      ),
    );
  }
}
