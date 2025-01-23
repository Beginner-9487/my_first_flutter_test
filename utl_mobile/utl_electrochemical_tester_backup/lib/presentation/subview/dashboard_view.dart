import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';
import 'package:utl_electrochemical_tester/application/repository/csv_file_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/file_repository.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/concrete_line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_info_view.dart';
import 'package:utl_electrochemical_tester/presentation/subview/line_chart/line_chart_view.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';

class DashboardView extends StatefulWidget {
  final LineChartInfoController lineChartInfoController;
  final LineChartModeController lineChartModeController;
  final LineChartTypesController lineChartTypesController;
  const DashboardView({
    super.key,
    required this.lineChartInfoController,
    required this.lineChartModeController,
    required this.lineChartTypesController,
  });
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  LineChartInfoController get lineChartInfoController => widget.lineChartInfoController;
  LineChartModeController get lineChartModeController => widget.lineChartModeController;
  LineChartTypesController get lineChartTypesController => widget.lineChartTypesController;
  late final ElectrochemicalDataService electrochemicalDataService;
  update() {
    setState(() {});
  }
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    electrochemicalDataService = context.read<ElectrochemicalDataService>();
  }
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final LineChartInfoView lineChartInfoView = ConcreteLineChartInfoView(
      lineChartInfoController: lineChartInfoController,
      lineChartTypesController: lineChartTypesController,
      lineChartModeController: lineChartModeController,
    );
    final List<IconButton> toolButtons = [
      IconButton(
        onPressed: () {
          FileRepository fileRepository = CsvFileRepository(
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
    final List<IconData> modeIconData = [
      Icons.indeterminate_check_box,
      Icons.timer,
      Icons.volcano,
    ];
    final List<Widget> lineChartModeButtons = List.generate(LineChartMode.values.length, (index) {
      iconBuilder() => ValueListenableBuilder(
          valueListenable: widget.lineChartModeController,
          builder: (context, mode, child) => Icon(
            modeIconData[index],
            color: (mode.index == index) ? Colors.green : Colors.grey,
          )
      );
      return IconButton(
        onPressed: () {
          widget.lineChartModeController.mode = LineChartMode.values[index];
        },
        icon: iconBuilder(),
      );
    });
    final List<Widget> lineChartTypeFilterButtons = ElectrochemicalType
        .values
        .indexed
        .map((element) => ValueListenableBuilder(
            valueListenable: lineChartTypesController,
            builder: (context, types, child) {
              return IconButton(
                onPressed: () {
                  List<bool> shows = lineChartTypesController.shows.toList();
                  shows[element.$1] = !shows[element.$1];
                  lineChartTypesController.shows = shows;
                },
                icon: ElectrochemicalTypeIcons.icons.skip(element.$1).first,
                color: types[element.$1].show ? Colors.blue : Colors.grey,
              );
            },
        ))
        .toList();
    final List<List<Widget>> buttonsBoard = [
      [
        ...toolButtons,
        Spacer(),
        ...lineChartModeButtons,
      ],
      lineChartTypeFilterButtons,
    ];
    final Widget view = Column(
      children: [
        ...buttonsBoard.map((b) => Row(
          children: [
            ...b,
          ],
        )),
        Divider(),
        Expanded(
          child: lineChartInfoView,
        ),
      ],
    );
    return view;
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}