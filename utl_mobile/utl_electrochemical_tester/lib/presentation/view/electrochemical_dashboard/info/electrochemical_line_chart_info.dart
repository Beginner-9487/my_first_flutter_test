import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/info/electrochemical_line_chart_info_tile.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

class ElectrochemicalLineChartInfo extends StatelessWidget {
  const ElectrochemicalLineChartInfo({super.key});
  @override
  Widget build(BuildContext context) {
    var electrochemicalLineChartInfoController = ControllerRegistry.electrochemicalLineChartInfoController;
    var mode = electrochemicalLineChartInfoController.lineChartInfoChangeNotifier.mode;
    return ChangeNotifierProvider<LineChartInfoChangeNotifier>(
      create: (_) => electrochemicalLineChartInfoController.lineChartInfoChangeNotifier,
      child: Consumer<LineChartInfoChangeNotifier>(
        builder: (context, infoNotifier, child) {
          var infoList = infoNotifier.info;
          return ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              var infoDto = infoList[index];
              return ElectrochemicalLineChartInfoTile(infoDto: infoDto, mode: mode);
            },
          );
        },
      ),
    );
  }
}
