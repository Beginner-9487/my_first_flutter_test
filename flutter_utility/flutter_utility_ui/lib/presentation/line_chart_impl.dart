import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_utility_ui/presentation/line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Line_Chart_Impl extends Line_Chart {
  Line_Chart_Impl({
    super.key,
    this.primaryYAxis,
    this.trackballBehavior,
    this.zoomPanBehavior,
    this.data = const [],
  });

  UpdateBloc bloc = UpdateBlocImpl();
  List<LineSeries<Point, double>> data;

  @override
  void update(List<LineSeries<Point, double>> data) {
    this.data = data;
    bloc.update();
  }

  @override
  int? index;

  final StreamController<TOUCH_EVENT> _onTouchEvent = StreamController.broadcast();
  @override
  StreamSubscription<TOUCH_EVENT> onTouchEvent(void Function(TOUCH_EVENT event) onTouchEvent) {
    return _onTouchEvent.stream.listen(onTouchEvent);
  }
  @override
  bool isTouched = false;

  @override
  State<Line_Chart_Impl> createState() => _Line_Chart_Impl_State();

  final ChartAxis? primaryYAxis;
  final TrackballBehavior? trackballBehavior;
  final ZoomPanBehavior? zoomPanBehavior;
}

class _Line_Chart_Impl_State<View extends Line_Chart_Impl> extends State<View> {
  UpdateBloc get bloc => widget.bloc;

  TrackballBehavior? get trackballBehavior => widget.trackballBehavior;
  ZoomPanBehavior? get zoomPanBehavior => widget.zoomPanBehavior;

  List<LineSeries<Point, double>> get data => widget.data;

  ChartAxis? get primaryYAxis => widget.primaryYAxis;

  bool get isTouched => widget.isTouched;
  setIsTouched(bool isTouched) {
    widget.isTouched = isTouched;
  }

  int? get index => widget.index;
  setIndex(int? index) {
    widget.index = index;
  }

  late final Widget view;

  @override
  void initState() {
    super.initState();
    view = BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          return SfCartesianChart(
            series: data,
            trackballBehavior: trackballBehavior,
            zoomPanBehavior: zoomPanBehavior,
            onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
              setIsTouched(true);
              widget._onTouchEvent.add(TOUCH_EVENT.TOUCH_DOWN);
            },
            onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
              setIsTouched(false);
              widget._onTouchEvent.add(TOUCH_EVENT.TOUCH_UP);
            },
            onTrackballPositionChanging: (TrackballArgs trackballArgs) {
              int? index = trackballArgs
                  .chartPointInfo
                  .dataPointIndex;
              setIndex(index);
              widget._onTouchEvent.add(TOUCH_EVENT.TOUCH_MOVE);
            },
            primaryYAxis: primaryYAxis,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return view;
  }
}