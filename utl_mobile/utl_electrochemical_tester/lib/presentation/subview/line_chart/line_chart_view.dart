import 'package:flutter/cupertino.dart';
import 'package:flutter_basic_utils/presentation/line_chart/line_chart.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

enum LineChartMode {
  ampereIndex,
  ampereTime,
  ampereVolt,
}

class LineChartModeController extends ValueNotifier<LineChartMode> {
  LineChartModeController({
    LineChartMode mode = LineChartMode.ampereVolt,
  }) : super(mode);
  set mode(LineChartMode mode) => super.value = mode;
  LineChartMode get mode => super.value;
}

class LineChartTypes{
  LineChartTypes({
    required this.type,
    required this.show,
  });
  ElectrochemicalType type;
  bool show;
}

class LineChartTypesController extends ValueNotifier<List<LineChartTypes>> {
  static List<LineChartTypes> get defaultTypes => showsToTypes(Iterable.empty());
  static List<LineChartTypes> showsToTypes(Iterable<bool> shows) {
    return ElectrochemicalType
      .values
      .indexed
      .map((element) => LineChartTypes(
        type: element.$2,
        show: shows.skip(element.$1).firstOrNull ?? true,
      ))
      .toList();
  }
  LineChartTypesController({
    Iterable<bool> shows = const Iterable.empty(),
  }) : super(showsToTypes(shows));
  set shows(Iterable<bool> shows) => super.value = showsToTypes(shows);
  Iterable<bool> get shows => super.value.map((type) => type.show);
}

abstract class LineChartView<Dataset> extends Widget {
  const LineChartView({
    super.key,
    void Function(LineChartTouchState touchState)? onTouchStateChanged,
    LineChartModeController? lineChartModeController,
    LineChartTypesController? lineChartTypesController,
  });
}