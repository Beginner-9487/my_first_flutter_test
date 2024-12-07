import 'dart:ui';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';

abstract class Electrochemical_UI_Data_Point {
  Duration get time_since_created;
  double get voltage;
  double get current;
}

abstract class Electrochemical_UI_Data {
  String get data_name;
  String get device_address;
  Electrochemical_Entity_Type get type;
  String get typeString;
  Color get color;
  DateTime get created_time;
  double get temperature;
  Iterable<Electrochemical_UI_Data_Point> get points;
}

abstract class Electrochemical_UI_Data_Factory {
  Electrochemical_UI_Data entity_to_data(Electrochemical_Entity entity);
  Iterable<Electrochemical_UI_Data> get data;
}

abstract class Electrochemical_File_Data_Point {
  int get time_since_created;
  int get voltage;
  int get current;
}

abstract class Electrochemical_File_Data {
  int get id;
  String get data_name;
  String get device_address;
  Electrochemical_Entity_Type get type;
  String get typeString;
  String get created_time;
  int get temperature;
  Iterable<Electrochemical_File_Data_Point> get points;
  Electrochemical_CA_Header? get CA_header;
  Electrochemical_CV_Header? get CV_header;
  Electrochemical_DPV_Header? get DPV_header;
}

abstract class Electrochemical_File_Data_Factory {
  Electrochemical_File_Data entity_to_data(Electrochemical_Entity entity);
  Iterable<Electrochemical_File_Data> get data;
}