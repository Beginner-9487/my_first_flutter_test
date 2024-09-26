import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/use_cases/mackay_entiry_to_color.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';

class MackayIRBLineChart extends StatefulWidget {
  MackayIRBLineChart({
    super.key,
    required this.mackayIRBRepository,
    required this.updateBloc,
    this.lineChartListenerBloc,
    this.primaryYAxis,
  });

  UpdateBloc updateBloc;
  LineChartListenerBloc? lineChartListenerBloc;

  final MackayIRBRepository mackayIRBRepository;

  ChartAxis? primaryYAxis;

  updateChart() {
    updateBloc.add(const UpdateEvent());
    lineChartListenerBloc?.add(LineChartEventRefresh());
  }

  @override
  State<MackayIRBLineChart> createState() => _MackayIRBLineChartState();
}

class _MackayIRBLineChartState<View extends MackayIRBLineChart> extends State<View> {
  static const START_TOUCH_SHOW_INFO_DELAY = 300;

  UpdateBloc get updateBloc => widget.updateBloc;
  LineChartListenerBloc? get lineChartListenerBloc => widget.lineChartListenerBloc;

  MackayIRBRepository get mackayIRBRepository => widget.mackayIRBRepository;

  late final MackayEntityToColor mackayEntityToColor;

  List<LineSeries<Point, double>> get _data => mackayIRBRepository.entities
      .map(
          (e) => LineSeries<Point, double>(
            name: e.data_name,
            dataSource: e.rows.map((e) => Point(e.created_time_related_to_entity_seconds, e.current)).toList(),
            animationDuration: 0,
            xValueMapper: (Point data, _) => data.x.toDouble(),
            yValueMapper: (Point data, _) => data.y.toDouble(),
            color: mackayEntityToColor.getColor(e),
            width: 1.5,
            onRendererCreated: (ChartSeriesController controller) {
              // controllers.add(controller);
            }
          )
      ).toList();

  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    mackayEntityToColor = MackayEntityToColor(mackayIRBRepository: mackayIRBRepository);
    _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        // shouldAlwaysShow: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.none,
    );
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        // enableDoubleTapZooming: true,
        enablePanning: true,
        // zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    // lineChartBlocMackayIrb.add(LineChartEventDispose());
    super.dispose();
  }

  int? lastSelectedXIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => updateBloc,
      child: BlocBuilder<UpdateBloc, UpdateState>(
          bloc: updateBloc,
          builder: (context, state) {
            return SfCartesianChart(
              series: _data,
              trackballBehavior: _trackballBehavior,
              zoomPanBehavior: _zoomPanBehavior,
              onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
                lineChartListenerBloc?.add(
                    LineChartEventTouch(true)
                );
                if(lastSelectedXIndex != null) {
                  Timer timer = Timer(const Duration(milliseconds: START_TOUCH_SHOW_INFO_DELAY), () {
                    _trackballBehavior.showByIndex(lastSelectedXIndex!);
                  });
                }
              },
              onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
                lineChartListenerBloc?.add(
                    LineChartEventTouch(false)
                );
              },
              onTrackballPositionChanging: (TrackballArgs trackballArgs) {
                int? selectedXIndex = trackballArgs
                    .chartPointInfo
                    .dataPointIndex;
                if(lastSelectedXIndex != null && lastSelectedXIndex == selectedXIndex) {
                  return;
                }
                lineChartListenerBloc?.add(
                    LineChartEventSetX(
                      selectedXIndex,
                    )
                );
                lastSelectedXIndex = selectedXIndex;
              },
              primaryYAxis: widget.primaryYAxis,
            );
          }),
    );
  }
}