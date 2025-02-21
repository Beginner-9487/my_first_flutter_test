import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

class ElectrochemicalLineChart extends StatelessWidget {
  const ElectrochemicalLineChart({super.key});
  @override
  Widget build(BuildContext context) {
    final electrochemicalLineChartController = ControllerRegistry.electrochemicalLineChartController;
    return ChangeNotifierProvider<LineChartSeriesListChangeNotifier>(
      create: electrochemicalLineChartController.createLineChartSeriesListChangeNotifier,
      child: Consumer<LineChartSeriesListChangeNotifier>(
        builder: (context, seriesListNotifier, child) {
          return SfCartesianChart(
            series: seriesListNotifier.seriesList,
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
              electrochemicalLineChartController.x = x;
            },
            trackballBehavior: TrackballBehavior(
              enable: true,
              shouldAlwaysShow: true,
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              // tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
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
