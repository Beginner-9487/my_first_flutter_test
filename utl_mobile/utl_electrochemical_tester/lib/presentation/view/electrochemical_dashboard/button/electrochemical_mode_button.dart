import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

import 'package:utl_electrochemical_tester/presentation/theme/theme_data.dart';

class ElectrochemicalModeButton extends StatelessWidget {
  final ElectrochemicalLineChartMode mode;
  const ElectrochemicalModeButton({
    super.key,
    required this.mode,
  });
  @override
  Widget build(BuildContext context) {
    final electrochemicalLineChartSetterController = ControllerRegistry.electrochemicalLineChartSetterController;
    return ChangeNotifierProvider<LineChartModeChangeNotifier>(
      create: electrochemicalLineChartSetterController.createLineChartModeChangeNotifier,
      child: Consumer<LineChartModeChangeNotifier>(
        builder: (context, modeNotifier, child) {
          final theme = Theme.of(context);
          int index = mode.index;
          final iconData = ElectrochemicalIcons.modeIconData.skip(index).first;
          Color? color = (modeNotifier.mode == mode)
            ? theme.lineChartModeEnabledColor
            : null;
          return IconButton(
            onPressed: () {
              electrochemicalLineChartSetterController.mode = mode;
            },
            icon: Icon(iconData),
            color: color,
          );
        },
      ),
    );
  }
}
