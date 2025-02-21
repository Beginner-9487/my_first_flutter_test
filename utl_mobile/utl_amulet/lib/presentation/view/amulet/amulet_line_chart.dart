import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_amulet/controller/amulet_line_chart_controller.dart';
import 'package:utl_amulet/init/controller_registry.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmuletLineChart extends StatelessWidget {
  const AmuletLineChart({super.key});
  @override
  Widget build(BuildContext context) {
    final amuletLineChartController = ControllerRegistry.amuletLineChartController;
    final appLocalizations = AppLocalizations.of(context)!;
    return ChangeNotifierProvider<AmuletLineChartSeriesListChangeNotifier>(
      create: (_) => amuletLineChartController.createSeriesListChangeNotifier(appLocalizations: appLocalizations),
      child: Consumer<AmuletLineChartSeriesListChangeNotifier>(
        builder: (context, seriesListNotifier, child) {
          return SfCartesianChart(
            series: seriesListNotifier.seriesList,
            onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
              amuletLineChartController.isTouched = true;
            },
            onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
              amuletLineChartController.isTouched = false;
            },
            onTrackballPositionChanging: (TrackballArgs trackballArgs) {
              int? seriesIndex = trackballArgs.chartPointInfo.seriesIndex;
              if(seriesIndex == null) return;
              int? dataPointIndex = trackballArgs.chartPointInfo.dataPointIndex;
              if(dataPointIndex == null) return;
              double? x = seriesListNotifier.seriesList
                .skip(trackballArgs.chartPointInfo.seriesIndex!)
                .firstOrNull
                ?.dataSource
                ?.skip(trackballArgs.chartPointInfo.dataPointIndex!)
                .firstOrNull
                ?.x
                .toDouble();
              amuletLineChartController.x = x;
            },
            trackballBehavior: TrackballBehavior(
              enable: true,
              shouldAlwaysShow: true,
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              // tooltipSettings: InteractiveTooltip(
              //   enable: true,
              // ),
              lineType: TrackballLineType.vertical,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              // enableDoubleTapZooming: true,
              enablePanning: true,
              // zoomMode: ZoomMode.x,
              enableMouseWheelZooming: true,
            ),
          );
        },
      ),
    );
  }
}
