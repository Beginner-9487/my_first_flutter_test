import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/line_chart/line_chart.dart' as line_chart;
import 'package:flutter_utility_ui/presentation/line_chart/syncfusion_line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_data_getter.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';

class ConcreteLineChartView extends StatefulWidget implements LineChartView {
  ChartAxis? primaryYAxis;
  @override
  final void Function(line_chart.LineChartTouchState, line_chart.LineChartTouchState)? onTouchStateChanged;
  final LineChartModeController? lineChartModeController;
  final LineChartTypesController? lineChartTypesController;
  ConcreteLineChartView({
    super.key,
    this.primaryYAxis,
    this.onTouchStateChanged,
    this.lineChartModeController,
    this.lineChartTypesController,
  });
  @override
  State<ConcreteLineChartView> createState() => _ConcreteLineChartViewState();
}

class _ConcreteLineChartViewState extends State<ConcreteLineChartView> {
  late final ElectrochemicalDataService electrochemicalDataService;
  late final Widget view;
  late final SyncfusionLineChartDatasetController syncfusionLineChartDatasetController;
  late final StreamSubscription _onUpdate;
  late final StreamSubscription _onClear;
  LineChartMode get mode => widget.lineChartModeController?.mode ?? LineChartMode.values[0];
  Iterable<bool> get shows => widget.lineChartTypesController?.shows ?? LineChartTypesController.defaultShows;
  List<LineSeries<Point<num>, double>> get dataset => LineChartDataGetter
    .data(
      entities: electrochemicalDataService.latestEntities,
      shows: shows,
    )
    .map((dto) => LineSeries<Point, double>(
      name: dto.dataName,
      dataSource: dto.data.map((e) {
        switch(mode) {
          case LineChartMode.ampereIndex:
            return Point(
              e.index,
              e.current,
            );
          case LineChartMode.ampereTime:
            return Point(
              e.time,
              e.current,
            );
          case LineChartMode.ampereVolt:
            return Point(
              e.voltage,
              e.current,
            );
        }
      }).toList(),
      animationDuration: 0,
      xValueMapper: (Point data, _) => data.x.toDouble(),
      yValueMapper: (Point data, _) => data.y.toDouble(),
      color: dto.color,
      width: 1.5,
    )).toList();
  void update() {
    syncfusionLineChartDatasetController.dataset = dataset;
  }
  @override
  void initState() {
    super.initState();
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
    syncfusionLineChartDatasetController = SyncfusionLineChartDatasetController(
        dataset: dataset,
    );
    _onUpdate = electrochemicalDataService.onUpdate.listen((data) {
      update();
    });
    _onClear = electrochemicalDataService.onClear.listen((data) {
      update();
    });
    view = SyncfusionLineChart(
      datasetController: syncfusionLineChartDatasetController,
      primaryYAxis: widget.primaryYAxis,
      onTouchStateChanged: widget.onTouchStateChanged,
      trackballBehavior: TrackballBehavior(
        enable: true,
        shouldAlwaysShow: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        // tooltipSettings: InteractiveTooltip(
        //   enable: true,
        // ),
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        // enableDoubleTapZooming: true,
        enablePanning: true,
        // zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
      ),
    );
    widget.lineChartModeController?.modeValueNotifier.addListener(update);
    if(widget.lineChartTypesController != null) {
      for(var v in widget.lineChartTypesController!.typeValueNotifier) {
        v.addListener(update);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return view;
  }

  @override
  void dispose() {
    super.dispose();
    _onUpdate.cancel();
    _onClear.cancel();
    widget.lineChartModeController?.modeValueNotifier.removeListener(update);
    if(widget.lineChartTypesController != null) {
      for(var v in widget.lineChartTypesController!.typeValueNotifier) {
        v.removeListener(update);
      }
    }
  }
}