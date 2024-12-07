import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/widget_list.dart';
import 'package:flutter_utility_ui/presentation/widget_list_impl.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_line_chart_controller.dart';

abstract class Electrochemical_Line_Chart_Dashboard_View extends StatefulWidget {
  const Electrochemical_Line_Chart_Dashboard_View({super.key});
}

class Electrochemical_Line_Chart_Dashboard_View_Impl extends Electrochemical_Line_Chart_Dashboard_View {
  ContextResource contextResource;
  final Electrochemical_Line_Chart_Controller electrochemical_line_chart_controller;
  final Divider? divider_item;
  final Divider? divider_data;
  Electrochemical_Line_Chart_Dashboard_View_Impl({
    super.key,
    required this.contextResource,
    required this.electrochemical_line_chart_controller,
    this.divider_item,
    this.divider_data,
  });
  late Widget_List _widget_list;
  @override
  State<Electrochemical_Line_Chart_Dashboard_View_Impl> createState() => _Electrochemical_Line_Chart_Dashboard_View_Impl_State();
}

class _Electrochemical_Line_Chart_Dashboard_View_Impl_State<View extends Electrochemical_Line_Chart_Dashboard_View_Impl> extends State<View> {
  ContextResource get contextResource => widget.contextResource;
  Electrochemical_Line_Chart_Controller get electrochemical_line_chart_controller => widget.electrochemical_line_chart_controller;
  Iterable<Divider> get _divider_item => (widget.divider_item != null) ? [widget.divider_item!] : [];
  Iterable<Divider> get _divider_data => (widget.divider_data != null) ? [widget.divider_data!] : [];
  late final StreamSubscription _onDataUpdate;
  late final StreamSubscription _onLineChartTouchedIndexChange;
  Text _text_item_getter(ElectrochemicalDashboardData data, String text) {
    return Text(
      text,
      style: TextStyle(
        color: data.color,
      ),
    );
  }
  List<Widget> get widgets => electrochemical_line_chart_controller
      .dashboard_data.map((e) => Column(
        children: [
          Row(
            children: [
              _text_item_getter(e, contextResource.str.name),
              _text_item_getter(e, ": "),
              _text_item_getter(e, e.name),
              _text_item_getter(e, ",  "),
              _text_item_getter(e, e.created_time),
              _text_item_getter(e, ",  "),
              _text_item_getter(e, e.type),
              const Spacer(),
            ],
          ),
          ..._divider_item,
          Row(
            children: [
              _text_item_getter(e, contextResource.str.temperature),
              _text_item_getter(e, ": "),
              _text_item_getter(e, e.temperature.toStringAsFixed(4)),
              const Spacer(),
            ],
          ),
          ..._divider_item,
          Row(
            children: [
              _text_item_getter(e, contextResource.str.time),
              _text_item_getter(e, ": "),
              _text_item_getter(e, e.time_since_created.toString()),
              const Spacer(),
            ],
          ),
          ..._divider_item,
          Row(
            children: [
              _text_item_getter(e, contextResource.str.current),
              _text_item_getter(e, ": "),
              _text_item_getter(e, e.current.toString()),
              const Spacer(),
            ],
          ),
          ..._divider_data,
        ],
      ))
      .toList();
  @override
  void initState() {
    super.initState();
    widget._widget_list = Widget_List_Impl();
    _onDataUpdate = electrochemical_line_chart_controller.onDataUpdate((p0) {
      widget._widget_list.update(widgets);
    });
    _onLineChartTouchedIndexChange = electrochemical_line_chart_controller.onLineChartTouchedIndexChange((p0) {
      widget._widget_list.update(widgets);
    });
    widget._widget_list.update(widgets);
  }
  @override
  Widget build(BuildContext context) {
    return widget._widget_list;
  }
  @override
  void dispose() {
    super.dispose();
    _onDataUpdate.cancel();
    _onLineChartTouchedIndexChange.cancel();
  }
}