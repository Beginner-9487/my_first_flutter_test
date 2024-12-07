import 'dart:ui';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';

class Electrochemical_UI_Data_Point_Impl implements Electrochemical_UI_Data_Point {
  Electrochemical_UI_Data_Point_Impl({
    required this.current,
    required this.time_since_created,
    required this.voltage,
  });
  @override
  double current;
  @override
  double voltage;
  @override
  Duration time_since_created;
}

class Electrochemical_UI_Data_Impl implements Electrochemical_UI_Data {
  Electrochemical_UI_Data_Impl({
    required Electrochemical_Entity entity,
    required this.typeString,
    required this.color,
    required this.points,
    required this.temperature,
  }) :
        data_name = entity.data_name,
        type = entity.type,
        device_address = entity.device_address,
        created_time = DateTime.fromMicrosecondsSinceEpoch(entity.created_time)
  ;
  @override
  final String data_name;
  @override
  final String device_address;
  @override
  final Electrochemical_Entity_Type type;
  @override
  final String typeString;
  @override
  final Color color;
  @override
  final DateTime created_time;
  @override
  double temperature;
  @override
  final Iterable<Electrochemical_UI_Data_Point> points;
}

class Electrochemical_File_Data_Point_Impl implements Electrochemical_File_Data_Point {
  Electrochemical_File_Data_Point_Impl({
    required this.current,
    required this.time_since_created,
    required this.voltage,
  });
  @override
  int current;
  @override
  int voltage;
  @override
  int time_since_created;
}

class Electrochemical_File_Data_Impl implements Electrochemical_File_Data {
  Electrochemical_File_Data_Impl({
    required Electrochemical_Entity entity,
    required this.typeString,
    required this.points,
  }) :
        id = entity.id,
        data_name = entity.data_name,
        device_address = entity.device_address,
        created_time = DateTime.fromMicrosecondsSinceEpoch(entity.created_time).toString(),
        type = entity.type,
        temperature = entity.temperature,
        CA_header = entity.CA_header,
        CV_header = entity.CV_header,
        DPV_header = entity.DPV_header
  ;
  @override
  final int id;
  @override
  final String data_name;
  @override
  final String device_address;
  @override
  final Electrochemical_Entity_Type type;
  @override
  final String typeString;
  @override
  final String created_time;
  @override
  final int temperature;
  @override
  final Iterable<Electrochemical_File_Data_Point> points;
  @override
  final Electrochemical_CA_Header? CA_header;
  @override
  final Electrochemical_CV_Header? CV_header;
  @override
  final Electrochemical_DPV_Header? DPV_header;
}