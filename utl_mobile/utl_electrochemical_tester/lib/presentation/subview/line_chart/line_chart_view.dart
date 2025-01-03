import 'package:flutter/cupertino.dart';
import 'package:flutter_utility_ui/presentation/line_chart/line_chart.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

enum LineChartMode {
  ampereIndex,
  ampereTime,
  ampereVolt,
}

class LineChartModeController {
  ValueNotifier<LineChartMode> modeValueNotifier = ValueNotifier(LineChartMode.values[0]);
  set mode(LineChartMode mode) {
    modeValueNotifier.value = mode;
  }
  LineChartMode get mode => modeValueNotifier.value;
}

class LineChartTypes{
  LineChartTypes({
    required this.type,
    required this.show,
  });
  ElectrochemicalType type;
  bool show;
}

class LineChartTypesController {
  static List<bool> get defaultShows => List.generate(
    ElectrochemicalType.values.length,
    (index) {
      return true;
    },
  );
  final List<ValueNotifier<bool>> _typeValueNotifier = List.generate(
    ElectrochemicalType.values.length,
    (index) {
      return ValueNotifier(true);
    },
  );
  Iterable<ValueNotifier<bool>> get typeValueNotifier => _typeValueNotifier;

  set shows(Iterable<bool> shows) {
    for(int i=0; i<shows.length; i++) {
      _typeValueNotifier[i].value = shows.skip(i).first;
    }
  }
  Iterable<bool> get shows =>  _typeValueNotifier.map((v) => v.value);
}

abstract class LineChartView extends Widget {
  const LineChartView({
    super.key,
    this.onTouchStateChanged,
  });
  final void Function(LineChartTouchState oldState, LineChartTouchState newState)? onTouchStateChanged;
}
