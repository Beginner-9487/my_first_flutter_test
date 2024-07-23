import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';

class LineChartView extends StatefulWidget {
  LineChartView({
      super.key,
      this.data = const ([], []),
      required this.updateBloc,
      this.lineChartListenerBloc,
      this.primaryYAxis,
  });

  UpdateBloc updateBloc;
  LineChartListenerBloc? lineChartListenerBloc;
  (List<ChartSeriesController>, List<LineSeries<Point, double>>) data;

  List<ChartSeriesController> get _controllers => data.$1;
  List<LineSeries<Point, double>> get _data => data.$2;

  ChartAxis? primaryYAxis;

  updateChart((List<ChartSeriesController>, List<LineSeries<Point, double>>) newData) {
    data = newData;
    updateBloc.add(const UpdateEvent());
  }

  @override
  State<LineChartView> createState() => _LineChartViewState();
}

class _LineChartViewState<View extends LineChartView> extends State<View> {
  static const START_TOUCH_SHOW_INFO_DELAY = 300;

  UpdateBloc get updateBloc => widget.updateBloc;
  LineChartListenerBloc? get lineChartListenerBloc => widget.lineChartListenerBloc;
  List<ChartSeriesController> get _controllers => widget.data.$1;
  List<LineSeries<Point, double>> get _data => widget.data.$2;

  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
      _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        // shouldAlwaysShow: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
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

class LineChartViewInfo extends LineChartView {
  LineChartViewInfo({
    super.key,
    super.data,
    required super.updateBloc,
    super.lineChartListenerBloc,
    super.primaryYAxis,
  });

  @override
  State<LineChartViewInfo> createState() => _LineChartViewStateInfo();
}

class _LineChartViewStateInfo<View extends LineChartViewInfo> extends _LineChartViewState<View> {
  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      // shouldAlwaysShow: true,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
    );
  }
}

class LineChartViewGemini extends LineChartView {
  LineChartViewGemini({
    super.key,
    super.data,
    required super.updateBloc,
    super.lineChartListenerBloc,
    required this.isRightList,
  });

  List<bool> isRightList;

  @override
  State<LineChartViewGemini> createState() => _LineChartViewStateGemini();
}

class _LineChartViewStateGemini<View extends LineChartViewGemini> extends _LineChartViewState<View> {

  List<bool> get isRightList => widget.isRightList;
  int get _numberOfRight => isRightList.where((element) => element).length;
  int get _numberOfLeft => isRightList.length - _numberOfRight;
  int get _maxNumberOfData => max(_numberOfRight, _numberOfLeft);

  static const double xInfoHeight = 26.0;
  static const double yInfoHeight = 13.0;

  Widget _buildYInfo(LineSeries<Point<num>, double> y) {
    return Row(
      children: [
        Icon(
          Icons.add_chart,
          color: y.color,
        ),
        Text(
          "${y.name}: ${(lastSelectedXIndex != null && lastSelectedXIndex! < y.dataSource.length) ? y.dataSource[lastSelectedXIndex!].y : ""}",
          style: const TextStyle(
              fontSize: yInfoHeight,
              color: Color.fromRGBO(255, 255, 255, 1)
          )
        ),
      ],
    );
  }

  Widget trackballBuilder(BuildContext context, TrackballDetails trackballDetails) {
    String x = "";
    if(lastSelectedXIndex != null) {
      for(var d in _data) {
        if(lastSelectedXIndex! < d.dataSource.length) {
          x = d.dataSource[lastSelectedXIndex!].x.toString();
        }
      }
    }
    Text xInfo = Text(
        x,
        style: const TextStyle(
          fontSize: xInfoHeight,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
    );
    Column leftInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _data
          .indexed
          .where((e) => !isRightList[e.$1])
          .map((e) => _buildYInfo(e.$2))
          .toList(),
    );
    Column rightInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _data
          .indexed
          .where((e) => isRightList[e.$1])
          .map((e) => _buildYInfo(e.$2))
          .toList(),
    );
    return Container(
        height: (xInfoHeight + 15) + _maxNumberOfData * (yInfoHeight + 15),
        // width: (maxWidthLeft + maxWidthRight + 4) * 13 + 2 * (26),
        // width: 300,
        width: screenWidth(context) * 0.8,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 8, 22, 0.75),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Column(
          children: [
            xInfo,
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftInfo,
                const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: SizedBox(
                      // height: 30,
                      width: 5,
                    )
                ),
                rightInfo,
              ],
            )
          ],
        )
    );
  }

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      builder: trackballBuilder,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      markerSettings: const TrackballMarkerSettings(
          height: 10,
          width: 10,
          markerVisibility: TrackballVisibilityMode.visible,
          borderColor: Colors.black,
          borderWidth: 4,
          color: Colors.blue),
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
    );
  }
}