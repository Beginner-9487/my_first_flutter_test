import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

import 'package:utl_electrochemical_tester/resources/theme_data.dart';

class ElectrochemicalModeButton extends StatelessWidget {
  final ElectrochemicalLineChartMode mode;
  const ElectrochemicalModeButton({
    super.key,
    required this.mode,
  });
  @override
  Widget build(BuildContext context) {
    var electrochemicalLineChartSetterController = ControllerRegistry.electrochemicalLineChartSetterController;
    return ChangeNotifierProvider<LineChartDatasetModeChangeNotifier>(
      create: (_) => electrochemicalLineChartSetterController.lineChartMode,
      child: Consumer<LineChartDatasetModeChangeNotifier>(
        builder: (context, modeNotifier, child) {
          var theme = Theme.of(context);
          int index = mode.index;
          Color? color = (modeNotifier.mode == mode)
            ? theme.lineChartModeEnabledColor
            : null;
          return IconButton(
            onPressed: () {
              electrochemicalLineChartSetterController.mode = mode;
            },
            icon: ElectrochemicalIcons.modeIcons.skip(index).first,
            color: color,
          );
        },
      ),
    );
  }
}
