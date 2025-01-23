import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ElectrochemicalIcons {
  ElectrochemicalIcons._();
  static const ca = Icon(Icons.cabin);
  static const cv = Icon(Icons.calendar_view_day);
  static const dpv = Icon(Icons.dew_point);
  static Iterable<Icon> get typeIcons => ElectrochemicalType.values.map((type) {
    switch(type) {
      case ElectrochemicalType.ca:
        return ca;
      case ElectrochemicalType.cv:
        return cv;
      case ElectrochemicalType.dpv:
        return dpv;
    }
  });
  static const ampereIndex = Icon(Icons.indeterminate_check_box);
  static const ampereTime = Icon(Icons.timer);
  static const ampereVolt = Icon(Icons.volcano);
  static Iterable<Icon> get modeIcons => ElectrochemicalLineChartMode.values.map((type) {
    switch(type) {
      case ElectrochemicalLineChartMode.ampereIndex:
        return ampereIndex;
      case ElectrochemicalLineChartMode.ampereTime:
        return ampereTime;
      case ElectrochemicalLineChartMode.ampereVolt:
        return ampereVolt;
    }
  });
}
