import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:utl_electrochemical_tester/application/repository/csv_file_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/file_repository.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/concrete_line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';

class DashboardView extends StatefulWidget {
  final LineChartModeController lineChartModeController;
  final LineChartTypesController lineChartTypesController;
  DashboardView({
    super.key,
    required this.lineChartModeController,
    required this.lineChartTypesController,
  });
  LineChartInfoView? concreteLineChartInfoView;
  set x(double? x) => concreteLineChartInfoView?.x = x;
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  LineChartTypesController get lineChartTypesController => widget.lineChartTypesController;
  late final ElectrochemicalDataService electrochemicalDataService;
  late final RowCSVFileHandler rowCSVFileHandler;
  late final SystemPath systemPath;
  late final List<IconButton> toolButtons;
  late final List<Widget> lineChartModeButtons;
  late final List<Widget> lineChartTypeFilterButtons;
  late final List<List<Widget>> buttonsBoard;
  late final Widget view;
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
    rowCSVFileHandler = context.read<RowCSVFileHandler>();
    systemPath = context.read<SystemPath>();
    widget.concreteLineChartInfoView = ConcreteLineChartInfoView(
      lineChartTypesController: lineChartTypesController,
      lineChartModeController: widget.lineChartModeController,
    );
    toolButtons = [
      IconButton(
        onPressed: () {
          FileRepository fileRepository = CsvFileRepository(
            rowCSVFileHandler: rowCSVFileHandler,
            systemPath: systemPath,
            context: context,
          );
          electrochemicalDataService.saveFile(
              fileRepository
          );
        },
        icon: Icon(Icons.save),
      ),
      IconButton(
        onPressed: () => electrochemicalDataService.clear(),
        icon: Icon(Icons.clear),
      ),
    ];
    lineChartModeButtons = List.generate(LineChartMode.values.length, (index) {
      late final Widget icon;
      switch(LineChartMode.values[index]) {
        case LineChartMode.ampereIndex:
          icon = ValueListenableBuilder(
              valueListenable: widget.lineChartModeController.modeValueNotifier,
              builder: (context, mode, widget) => Icon(
                Icons.indeterminate_check_box,
                color: (mode.index == index) ? Colors.green : Colors.grey,
              )
          );
          break;
        case LineChartMode.ampereTime:
          icon = ValueListenableBuilder(
              valueListenable: widget.lineChartModeController.modeValueNotifier,
              builder: (context, mode, widget) => Icon(
                Icons.timer,
                color: (mode.index == index) ? Colors.green : Colors.grey,
              )
          );
          break;
        case LineChartMode.ampereVolt:
          icon = ValueListenableBuilder(
              valueListenable: widget.lineChartModeController.modeValueNotifier,
              builder: (context, mode, widget) => Icon(
                Icons.volcano,
                color: (mode.index == index) ? Colors.green : Colors.grey,
              )
          );
          break;
      }
      return IconButton(
        onPressed: () {
          widget.lineChartModeController.mode = LineChartMode.values[index];
        },
        icon: icon,
      );
    });
    lineChartTypeFilterButtons = lineChartTypesController.typeValueNotifier.indexed.map((v) => ValueListenableBuilder(
        valueListenable: v.$2,
        builder: (context, show, widget) {
          return IconButton(
            onPressed: () {
              List<bool> shows = lineChartTypesController.shows.toList();
              shows[v.$1] = !shows[v.$1];
              lineChartTypesController.shows = shows;
            },
            icon: ElectrochemicalTypeIcons.icons.skip(v.$1).first,
            color: show ? Colors.blue : Colors.grey,
          );
        },
    )).toList();
    buttonsBoard = [
      [
        ...toolButtons,
        Spacer(),
        ...lineChartModeButtons,
      ],
      lineChartTypeFilterButtons,
    ];
    view = Column(
      children: [
        ...buttonsBoard.map((b) => Row(
          children: [
            ...b,
          ],
        )),
        Divider(),
        Expanded(
          child: widget.concreteLineChartInfoView ?? Scaffold(),
        ),
      ],
    );
  }
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return view;
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.concreteLineChartInfoView = null;
    super.dispose();
  }
}