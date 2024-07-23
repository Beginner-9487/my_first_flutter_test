import 'dart:async';

abstract class LeakageRepository<RowData extends LeakageRow> {
  static const int ROW_MAX_LENGTH = 100;
  Iterable<RowData> get rows;
  StreamSubscription<LeakageRow> onAdd(void Function(LeakageRow row) doSomething);
  static const double EXTRA_LEAKAGE_WARNING_VOLTAGE = 5;
  static const double INTRA_LEAKAGE_WARNING_CAPACITANCE = 5;
}

abstract class LeakageRow {
  int get index;
  double get time;
  bool get isExtraLeakage;
  bool get isIntraOsmosis;
  double get extraVoltage;
  double get intraCapacitance;
}