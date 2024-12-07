import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_utility_ui/presentation/line_chart.dart';
import 'package:flutter_utility_ui/presentation/line_chart_impl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_line_chart_controller.dart';

abstract class Electrochemical_Line_Chart_View extends StatefulWidget {
  Electrochemical_Line_Chart_View({super.key});
  bool get isTouched;
  int? get index;
}

class Electrochemical_Line_Chart_View_Impl extends Electrochemical_Line_Chart_View {
  final Electrochemical_Line_Chart_Controller electrochemical_line_chart_controller;
  Electrochemical_Line_Chart_View_Impl({
    super.key,
    required this.electrochemical_line_chart_controller,
  });
  @override
  State<Electrochemical_Line_Chart_View_Impl> createState() => _Electrochemical_Line_Chart_View_Impl_State();
  late Line_Chart _line_chart;
  @override
  int? get index => _line_chart.index;
  @override
  bool get isTouched => _line_chart.isTouched;
}

class _Electrochemical_Line_Chart_View_Impl_State<View extends Electrochemical_Line_Chart_View_Impl> extends State<View> {
  Electrochemical_Line_Chart_Controller get electrochemical_line_chart_controller => widget.electrochemical_line_chart_controller;
  late final StreamSubscription _onDataUpdate;
  late final StreamSubscription<TOUCH_EVENT> _onTouchEvent;
  @override
  void initState() {
    super.initState();
    widget._line_chart = Line_Chart_Impl(
      trackballBehavior: TrackballBehavior(
        // Enables the trackball
        enable: true,
        // shouldAlwaysShow: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.none,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        // enableDoubleTapZooming: true,
        enablePanning: true,
        // zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
      ),
    );
    _onDataUpdate = electrochemical_line_chart_controller.onDataUpdate((p0) {
      widget._line_chart.update(electrochemical_line_chart_controller.line_chart_data);
    });
    _onTouchEvent = widget._line_chart.onTouchEvent((event) {
      electrochemical_line_chart_controller.setLineChartTouchedIndex(widget._line_chart.index);
    });
    widget._line_chart.update(electrochemical_line_chart_controller.line_chart_data);
  }
  @override
  Widget build(BuildContext context) {
    return widget._line_chart;
  }
  @override
  void dispose() {
    super.dispose();
    _onDataUpdate.cancel();
    _onTouchEvent.cancel();
  }
}