import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';

int _ID_counter = 0;

class Electrochemical_Entity_Impl implements Electrochemical_Entity {
  Electrochemical_Entity_Impl({
    required this.data_name,
    required this.device_address,
    required this.type,
    required this.temperature,
    this.CA_header,
    this.CV_header,
    this.DPV_header,
  });
  @override
  final String data_name;
  @override
  final String device_address;
  @override
  Electrochemical_Entity_Type type;
  @override
  final int id = _ID_counter++;
  @override
  final int created_time = DateTime.now().microsecondsSinceEpoch;
  @override
  final int temperature;
  @override
  final List<int> currents = [];
  @override
  Electrochemical_CA_Header? CA_header;
  @override
  Electrochemical_CV_Header? CV_header;
  @override
  Electrochemical_DPV_Header? DPV_header;
}

class Electrochemical_CA_Header_Impl implements Electrochemical_CA_Header {
  @override
  final int E_dc;
  @override
  final int t_interval;
  @override
  final int t_run;

  Electrochemical_CA_Header_Impl({
    required this.E_dc,
    required this.t_interval,
    required this.t_run,
  });
}

class Electrochemical_CV_Header_Impl implements Electrochemical_CV_Header {
  @override
  final int E_begin;
  @override
  final int E_vertex1;
  @override
  final int E_vertex2;
  @override
  final int E_step;
  @override
  final int scan_rate;
  @override
  final int number_of_scans;

  Electrochemical_CV_Header_Impl({
    required this.E_begin,
    required this.E_vertex1,
    required this.E_vertex2,
    required this.E_step,
    required this.scan_rate,
    required this.number_of_scans,
  });
}

class Electrochemical_DPV_Header_Impl implements Electrochemical_DPV_Header {
  @override
  final int E_begin;
  @override
  final int E_end;
  @override
  final int E_step;
  @override
  final int E_pulse;
  @override
  final int t_pulse;
  @override
  final int scan_rate;

  Electrochemical_DPV_Header_Impl({
    required this.E_begin,
    required this.E_end,
    required this.E_step,
    required this.E_pulse,
    required this.t_pulse,
    required this.scan_rate,
  });
}