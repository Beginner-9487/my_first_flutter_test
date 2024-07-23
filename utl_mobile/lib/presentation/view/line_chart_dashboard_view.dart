import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_state.dart';

class LineChartDashboardView extends StatefulWidget {
  LineChartDashboardView({
    super.key,
    required this.lineChartDashboardTile,
    required this.lineChartListenerBloc,
    this.divider,
    this.rows = const [],
  });

  LineChartListenerBloc lineChartListenerBloc;
  List<LineChartDashboardRow> rows;

  Widget Function(LineChartDashboardRow row) lineChartDashboardTile;

  Widget? divider;

  updateChart(List<LineChartDashboardRow> newData) {
    rows = newData;
    lineChartListenerBloc.add(LineChartEventRefresh());
  }

  @override
  State<LineChartDashboardView> createState() => _LineChartDashboardViewState();
}

class _LineChartDashboardViewState extends State<LineChartDashboardView> {
  LineChartListenerBloc get lineChartListenerBloc => widget.lineChartListenerBloc;

  Widget Function(LineChartDashboardRow row) get lineChartDashboardTile => widget.lineChartDashboardTile;

  Widget? get divider => widget.divider;

  List<LineChartDashboardRow> get _rows => widget.rows;

  int? get _xIndex => lineChartListenerBloc.xIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // lineChartBloc.add(LineChartEventDispose());
    super.dispose();
  }

  // static int _buildDataTilesKeyCounter = 0;
  List<Widget> _buildDataTiles(BuildContext context) {
    List<Widget> list = _rows
      .map((e) => BlocProvider(
        create: (context) => lineChartListenerBloc,
        child: BlocBuilder<LineChartListenerBloc, LineChartState>(
            bloc: lineChartListenerBloc,
            builder: (context, state) {
              return lineChartDashboardTile(e);
            }
        ),
      ))
      .toList();
    if(list.isEmpty) {
      return [];
    } else if(divider != null && list.length > 1) {
      for(int i = list.length - 1; i>0; i--) {
        // list.insert(i, divider!);
        list.insert(i, BlocProvider(
          create: (context) => lineChartListenerBloc,
          child: divider!,
        ));
      }
    }
    return list;
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
                  ..._buildDataTiles(context),
                ],
              );
            }
        ),
    );
  }
}