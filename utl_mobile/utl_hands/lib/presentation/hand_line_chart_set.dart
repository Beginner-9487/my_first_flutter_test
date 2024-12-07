import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/use_case/hand_to_line_chart.dart';
import 'package:utl_hands/presentation/hand_line_chart.dart';

class HandLineChartSet extends StatefulWidget {
  const HandLineChartSet({
    super.key,
    required this.handRepository,
  });
  final HandRepository handRepository;

  @override
  State createState() => _HandLineChartSetState();
}

class _HandLineChartSetState extends State<HandLineChartSet> {
  HandRepository get handRepository => widget.handRepository;

  late StreamSubscription<(bool, HandRow)> _onAdd;

  late HandToLineChart handToLineChart;

  late HandLineChart leftHandLineChart;
  late HandLineChart rightHandLineChart;

  @override
  void initState() {
    super.initState();
    handToLineChart = HandToLineChart(handRepository);

    leftHandLineChart = HandLineChart(handRepository: handRepository);
    rightHandLineChart = HandLineChart(handRepository: handRepository);

    _onAdd = handRepository.onAdd((isRight, row) {
      if(isRight) {
        rightHandLineChart.update(handToLineChart.right.toList());
      } else {
        leftHandLineChart.update(handToLineChart.left.toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Left Hand",
          style: TextStyle(fontSize: 14),
        ),
        Expanded(child: leftHandLineChart),
        const Text(
          "Right Hand",
          style: TextStyle(fontSize: 14),
        ),
        Expanded(child: rightHandLineChart),
      ],
    );
  }

}