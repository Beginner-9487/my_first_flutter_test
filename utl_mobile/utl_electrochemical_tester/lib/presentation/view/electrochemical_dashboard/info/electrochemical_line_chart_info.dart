import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/info/electrochemical_line_chart_info_tile.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ElectrochemicalLineChartInfo extends StatelessWidget {
  const ElectrochemicalLineChartInfo({super.key});
  @override
  Widget build(BuildContext context) {
    var electrochemicalLineChartInfoController = ControllerRegistry.electrochemicalLineChartInfoController;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LineChartInfoListChangeNotifier>(
          create: electrochemicalLineChartInfoController.createLineChartInfoListChangeNotifier,
        ),
        ChangeNotifierProvider<LineChartModeChangeNotifier>(
          create: electrochemicalLineChartInfoController.createLineChartModeChangeNotifier,
        ),
        ChangeNotifierProvider<LineChartXChangeNotifier>(
          create: electrochemicalLineChartInfoController.createLineChartXChangeNotifier,
        ),
      ],
      child: Consumer3<LineChartInfoListChangeNotifier, LineChartModeChangeNotifier, LineChartXChangeNotifier>(
        builder: (context, infoListNotifier, modeNotifier, xNotifier, child) {
          final infoList = infoListNotifier.infoList;
          final mode = modeNotifier.mode;
          final x = xNotifier.x;
          var infoXText = Builder(
            builder: (context) {
              String label;
              final appLocalizations = AppLocalizations.of(context)!;
              switch (mode) {
                case ElectrochemicalLineChartMode.ampereIndex:
                  label = appLocalizations.index;
                  break;
                case ElectrochemicalLineChartMode.ampereTime:
                  label = appLocalizations.time;
                  break;
                case ElectrochemicalLineChartMode.ampereVolt:
                  label = appLocalizations.voltage;
                  break;
              }
              String infoX = "$label: ${x ?? ""}";
              return Text(
                infoX,
                softWrap: true,
              );
            },
          );
          return Column(
            children: [
              infoXText,
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: infoList.length,
                  itemBuilder: (context, index) {
                    var infoDto = infoList[index];
                    return ElectrochemicalLineChartInfoTile(infoDto: infoDto, mode: mode);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
