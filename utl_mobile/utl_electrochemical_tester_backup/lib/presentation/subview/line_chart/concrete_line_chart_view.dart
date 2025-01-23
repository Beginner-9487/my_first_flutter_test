import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_basic_utils/presentation/line_chart/line_chart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_data_getter.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';

class ConcreteLineChartView extends StatefulWidget implements LineChartView<List<LineSeries<Point, double>>> {
  const ConcreteLineChartView({
    super.key,
    this.onTouchStateChanged,
    this.lineChartModeController,
    this.lineChartTypesController,
  });
  final void Function(LineChartTouchState touchState)? onTouchStateChanged;
  final LineChartModeController? lineChartModeController;
  final LineChartTypesController? lineChartTypesController;
  @override
  State createState() => _ConcreteLineChartViewState();
}

class _ConcreteLineChartViewState extends State<ConcreteLineChartView> {
  late final ElectrochemicalDataService electrochemicalDataService;
  late final LineChartDatasetController<List<LineSeries<Point, double>>> lineChartDatasetController;
  List<LineSeries<Point<num>, double>> get createSeries => LineChartDataGetter
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
  LineChartMode get mode => widget.lineChartModeController?.mode ?? LineChartMode.values[0];
  Iterable<bool> get shows => widget.lineChartTypesController?.shows ?? LineChartTypesController.defaultTypes.map((type) => type.show);
  late final StreamSubscription _onUpdate;
  late final StreamSubscription _onClear;
  void update() {
    lineChartDatasetController.dataset = createSeries;
  }
  @override
  void initState() {
    super.initState();
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
    lineChartDatasetController = LineChartDatasetController(dataset: createSeries);
    widget.lineChartModeController?.addListener(update);
    widget.lineChartTypesController?.addListener(update);
    _onUpdate = electrochemicalDataService.onUpdate.listen((data) {
      update();
    });
    _onClear = electrochemicalDataService.onClear.listen((data) {
      update();
    });
  }
  @override
  Widget build(BuildContext context) {
    return LineChart(
      builder: (
        BuildContext context,
        void Function(double? x) touchDown,
        void Function(double? x) touchMove,
        void Function(double? x) touchUp,
      ) {
        return SfCartesianChart(
          series: lineChartDatasetController.dataset,
          onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
            touchDown(null);
          },
          onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
            touchUp(null);
          },
          onTrackballPositionChanging: (TrackballArgs trackballArgs) {
            int? seriesIndex = trackballArgs.chartPointInfo.seriesIndex;
            if(seriesIndex == null) return;
            int? dataPointIndex = trackballArgs.chartPointInfo.dataPointIndex;
            if(dataPointIndex == null) return;
            double? x = lineChartDatasetController.dataset
              .skip(trackballArgs.chartPointInfo.seriesIndex!)
              .firstOrNull
              ?.dataSource
              ?.skip(trackballArgs.chartPointInfo.dataPointIndex!)
              .firstOrNull
              ?.x
              .toDouble();
            touchMove(x);
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
      lineChartDatasetController: lineChartDatasetController,
      onTouchStateChanged: widget.onTouchStateChanged,
    );
  }
  @override
  void dispose() {
    lineChartDatasetController.dispose();
    widget.lineChartModeController?.removeListener(update);
    widget.lineChartTypesController?.removeListener(update);
    _onUpdate.cancel();
    _onClear.cancel();
    super.dispose();
  }
}