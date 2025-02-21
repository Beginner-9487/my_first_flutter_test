import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_amulet/controller/amulet_line_chart_controller.dart';
import 'package:utl_amulet/controller/dto/controller_dto_mapper.dart';
import 'package:utl_amulet/init/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _Item extends StatelessWidget {
  final String label;
  final String data;
  const _Item({
    super.key,
    required this.label,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      "$label: $data",
    );
  }
}

class AmuletDashboard extends StatelessWidget {
  const AmuletDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final amuletLineChartInfoController = ControllerRegistry.amuletLineChartInfoController;
    return ChangeNotifierProvider<AmuletLineChartInfoChangeNotifier>(
      create: (_) => amuletLineChartInfoController.createInfoChangeNotifier(),
      child: Consumer<AmuletLineChartInfoChangeNotifier>(
        builder: (context, infoNotifier, child) {
          final appLocalizations = AppLocalizations.of(context)!;
          final xLabel = infoNotifier.getXLabel(appLocalizations: appLocalizations);
          final xData = infoNotifier.getXData();
          return Column(
            children: [
              _Item(
                label: xLabel,
                data: xData,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: AmuletLineChartItem.values.length,
                  itemBuilder: (context, index) {
                    final appLocalizations = AppLocalizations.of(context)!;
                    final item = AmuletLineChartItem.values[index];
                    final yLabel = infoNotifier.getYLabel(appLocalizations: appLocalizations, item: item);
                    final yData = infoNotifier.getYData(item: item);
                    return _Item(
                      label: yLabel,
                      data: yData,
                    );
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
