import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/button/electrochemical_clear_button.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/button/electrochemical_download_button.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/info/electrochemical_line_chart_info.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/button/electrochemical_mode_button.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_dashboard/button/electrochemical_type_show_button.dart';

class ElectrochemicalLineChartDashboard extends StatelessWidget {
  const ElectrochemicalLineChartDashboard({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var lineChartInfoView = ElectrochemicalLineChartInfo();
    var toolButtons = [
      ElectrochemicalDownloadButton(),
      ElectrochemicalClearButton(),
    ];
    final List<Widget> lineChartModeButtons = ElectrochemicalLineChartMode.values.map((mode) => ElectrochemicalModeButton(mode: mode)).toList();
    final List<Widget> lineChartTypeShowButtons = ElectrochemicalType.values.map((type) => ElectrochemicalTypeShowButton(type: type)).toList();
    final List<List<Widget>> buttonsBoard = [
      [
        ...toolButtons,
        Spacer(),
        ...lineChartModeButtons,
      ],
      lineChartTypeShowButtons,
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
}
