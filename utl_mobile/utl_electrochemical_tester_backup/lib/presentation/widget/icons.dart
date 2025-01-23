import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

class ElectrochemicalTypeIcons {
  ElectrochemicalTypeIcons._();
  static const ca = Icon(Icons.cabin);
  static const cv = Icon(Icons.calendar_view_day);
  static const dpv = Icon(Icons.dew_point);
  static Iterable<Icon> get icons => Iterable.generate(ElectrochemicalType.values.length, (index) {
    switch(index) {
      case 0:
        return ca;
      case 1:
        return cv;
      case 2:
        return dpv;
      default:
        throw Exception("icons");
    }
  });
}