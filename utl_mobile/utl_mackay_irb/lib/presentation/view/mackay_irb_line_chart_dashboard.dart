import 'package:flutter_r/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/use_cases/mackay_entiry_to_color.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_state.dart';

class MackayIRBLineChartDashBoard extends StatefulWidget {
  MackayIRBLineChartDashBoard({
    super.key,
    this.divider_data,
    this.divider_item,
    required this.mackayIRBRepository,
    required this.lineChartListenerBloc,
  }) : _mackayEntityToColor = MackayEntityToColor(mackayIRBRepository: mackayIRBRepository);

  final MackayIRBRepository mackayIRBRepository;
  final MackayEntityToColor _mackayEntityToColor;
  final LineChartListenerBloc lineChartListenerBloc;

  Widget? divider_data;
  Widget? divider_item;

  updateChart() {
    lineChartListenerBloc.add(LineChartEventRefresh());
  }

  @override
  State<MackayIRBLineChartDashBoard> createState() => _MackayIRBLineChartDashBoardState();
}

class _MackayIRBLineChartDashBoardState extends State<MackayIRBLineChartDashBoard> {
  LineChartListenerBloc get lineChartListenerBloc => widget.lineChartListenerBloc;
  MackayIRBRepository get mackayIRBRepository => widget.mackayIRBRepository;
  MackayEntityToColor get mackayEntityToColor => widget._mackayEntityToColor;

  Iterable<Widget> get divider_data => (widget.divider_data != null) ? [widget.divider_data!] : [];
  Iterable<Widget> get divider_item => (widget.divider_item != null) ? [widget.divider_item!] : [];

  int? get _xIndex => lineChartListenerBloc.xIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Text _text_item_getter(String text, [MackayIRBEntity? entity]) {
    TextStyle? style = (entity != null)
        ? TextStyle(
          color: mackayEntityToColor.getColor(entity),
        )
        : null;
    return Text(
        text,
        style: style,
    );
  }

  List<Widget> _buildDataTiles() {
    return mackayIRBRepository.entities.map(
        (e) => Column(
          children: [
            Row(
              children: [
                _text_item_getter(R.str.name, e),
                _text_item_getter(": ", e),
                _text_item_getter(e.data_name, e),
                _text_item_getter(",  ", e),
                _text_item_getter(e.created_time_format_simple, e),
                _text_item_getter(",  ", e),
                _text_item_getter(e.type_name, e),

                const Spacer(),
              ],
            ),

            ...divider_item,

            Row(
              children: [
                _text_item_getter(R.str.temperature, e),
                _text_item_getter(": ", e),
                _text_item_getter(e.temperature.toStringAsFixed(4), e),

                const Spacer(),
              ],
            ),

            ...divider_item,

            Row(
              children: [
                _text_item_getter(R.str.time, e),
                _text_item_getter(": ", e),
                _text_item_getter(
                  (_xIndex != null && _xIndex! < e.rows.length)
                      ? e.rows.skip(_xIndex!).first.created_time_related_to_entity_format
                      : "",
                  e,
                ),

                const Spacer(),
              ],
            ),

            ...divider_item,

            Row(
              children: [
                _text_item_getter(R.str.current, e),
                _text_item_getter(": ", e),
                _text_item_getter(
                  (_xIndex != null && _xIndex! < e.rows.length)
                      ? e.rows.skip(_xIndex!).first.current.toStringAsFixed(4)
                      : "",
                  e,
                ),

                const Spacer(),
              ],
            ),

            ...divider_data,
          ],
        )
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => lineChartListenerBloc,
      child: BlocBuilder<LineChartListenerBloc, LineChartState>(
          bloc: lineChartListenerBloc,
          builder: (context, blueState) {
            return ListView(
              children: <Widget>[
                ..._buildDataTiles(),
              ],
            );
          }
      ),
    );
  }
}