import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:utl_electrochemical_tester/application/dto/electrochemical_ui_dto.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_data_getter.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConcreteLineChartInfoView extends StatefulWidget implements LineChartInfoView {
  @override
  final LineChartModeController? lineChartModeController;
  final LineChartTypesController? lineChartTypesController;
  ConcreteLineChartInfoView({
    super.key,
    this.lineChartModeController,
    this.lineChartTypesController,
  });
  final ValueNotifier<double?> _xValueNotifier = ValueNotifier(null);
  @override
  set x(double? x) {
    if(x == null) return;
    _xValueNotifier.value = x;
  }
  @override
  State<ConcreteLineChartInfoView> createState() => _ConcreteLineChartInfoViewState();
}

class _Item {
  String label;
  String data;
  _Item({
    required this.label,
    required this.data,
  });
}

class _ConcreteLineChartInfoViewState extends State<ConcreteLineChartInfoView> {
  late final ElectrochemicalDataService electrochemicalDataService;
  late final StreamSubscription _onUpdate;
  late final StreamSubscription _onClear;
  LineChartMode get mode => widget.lineChartModeController?.mode ?? LineChartMode.values[0];
  Iterable<bool> get shows => widget.lineChartTypesController?.shows ?? LineChartTypesController.defaultShows;
  Iterable<ElectrochemicalUiDto> dataset = [];
  Widget buildText({
    required List<_Item> items,
    required Color color,
  }) {
    String text = (items.isNotEmpty) ? "${items.first.label}: ${items.first.data}" : "";
    for(int i=1; i<items.length; i++) {
      text += ", ${items.skip(i).first.label}: ${items.skip(i).first.data}";
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  Widget buildText2({
    required String label,
    required Iterable<String> data,
    required Color color,
  }) {
    String text = (data.isNotEmpty) ? data.first : "";
    for(int i=1; i<data.length; i++) {
      text += ", ${data.skip(i).first}";
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            "$label: $text",
            softWrap: true,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  void update() {
    setState(() {
      dataset = LineChartDataGetter.data(
        entities: electrochemicalDataService.latestEntities,
        shows: shows,
      );
    });
  }
  @override
  void initState() {
    super.initState();
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
    _onUpdate = electrochemicalDataService.onUpdate.listen((data) {
      update();
    });
    _onClear = electrochemicalDataService.onClear.listen((data) {
      update();
    });
    widget._xValueNotifier.addListener(update);
    widget.lineChartModeController?.modeValueNotifier.addListener(update);
    if(widget.lineChartTypesController != null) {
      for(var v in widget.lineChartTypesController!.typeValueNotifier) {
        v.addListener(update);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataset.length,
      itemBuilder: (context, index) {
        AppLocalizations appLocalizations = context.appLocalizations!;
        _Item xItem;
        switch(mode) {
          case LineChartMode.ampereIndex:
            xItem = _Item(label: appLocalizations.index, data: widget._xValueNotifier.value.toString());
            break;
          case LineChartMode.ampereTime:
            xItem = _Item(label: appLocalizations.time, data: widget._xValueNotifier.value.toString());
            break;
          case LineChartMode.ampereVolt:
            xItem = _Item(label: appLocalizations.voltage, data: widget._xValueNotifier.value.toString());
            break;
        }
        Widget yItem;
        switch(mode) {
          case LineChartMode.ampereIndex:
            yItem = buildText2(label: appLocalizations.current, data: dataset.skip(index).first.data.where((e) => e.index == widget._xValueNotifier.value).map((e) => e.current.toString()), color: dataset.skip(index).first.color);
            break;
          case LineChartMode.ampereTime:
            yItem = buildText2(label: appLocalizations.current, data: dataset.skip(index).first.data.where((e) => e.time == widget._xValueNotifier.value).map((e) => e.current.toString()), color: dataset.skip(index).first.color);
            break;
          case LineChartMode.ampereVolt:
            yItem = buildText2(label: appLocalizations.current, data: dataset.skip(index).first.data.where((e) => e.voltage == widget._xValueNotifier.value).map((e) => e.current.toString()), color: dataset.skip(index).first.color);
            break;
        }
        return Column(
          children: [
            buildText(
              items: [
                _Item(
                    label: appLocalizations.name,
                    data: dataset.skip(index).first.dataName,
                ),
                _Item(
                  label: appLocalizations.type,
                  data: dataset.skip(index).first.type.name,
                ),
                _Item(
                  label: appLocalizations.temperature,
                  data: dataset.skip(index).first.temperature.toString(),
                ),
              ],
              color: dataset.skip(index).first.color,
            ),
            buildText(
              items: [
                _Item(
                  label: appLocalizations.time,
                  data: dataset.skip(index).first.createdTime.toString(),
                ),
              ],
              color: dataset.skip(index).first.color,
            ),
            buildText(
              items: [
                xItem,
              ],
              color: dataset.skip(index).first.color,
            ),
            yItem,
            Divider(),
          ],
        );
      }
    );
  }
  @override
  void dispose() {
    super.dispose();
    _onUpdate.cancel();
    _onClear.cancel();
    widget._xValueNotifier.removeListener(update);
    widget.lineChartModeController?.modeValueNotifier.removeListener(update);
    if(widget.lineChartTypesController != null) {
      for(var v in widget.lineChartTypesController!.typeValueNotifier) {
        v.removeListener(update);
      }
    }
  }
}