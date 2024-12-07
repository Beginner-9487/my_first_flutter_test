import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_utility_ui/presentation/traceball_builder/traceball_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TraceBallBuilderGemini extends TraceBallBuilderBase {

  TraceBallBuilderGemini(this.isRightList);

  MediaQueryData mediaQueryData(BuildContext context) => MediaQuery.of(context);

  List<bool> isRightList;
  int get _numberOfRight => isRightList.where((element) => element).length;
  int get _numberOfLeft => isRightList.length - _numberOfRight;
  int get _maxNumberOfData => max(_numberOfRight, _numberOfLeft);

  static const double xInfoHeight = 26.0;
  static const double yInfoHeight = 13.0;

  Widget _buildYInfo(TrackballDetails trackballDetails, LineSeries<Point<num>, double> y) {
    return Row(
      children: [
        Icon(
          Icons.add_chart,
          color: y.color,
        ),
        Text(
            "${y.name}: ${(lastSelectedXIndex! < y.dataSource.length) ? y.dataSource[lastSelectedXIndex!].y : ""}",
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
    if (lastSelectedXIndex != null) {
      for (var d in data) {
        if (lastSelectedXIndex! < d.dataSource.length) {
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
      children: data
          .indexed
          .where((e) => !isRightList[e.$1])
          .map((e) => _buildYInfo(trackballDetails, e.$2))
          .toList(),
    );
    Column rightInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data
          .indexed
          .where((e) => isRightList[e.$1])
          .map((e) => _buildYInfo(trackballDetails, e.$2))
          .toList(),
    );
    return Container(
        height: (xInfoHeight + 15) + _maxNumberOfData * (yInfoHeight + 15),
        // width: (maxWidthLeft + maxWidthRight + 4) * 13 + 2 * (26),
        // width: 300,
        width: mediaQueryData(context).size.width * 0.8,
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
}