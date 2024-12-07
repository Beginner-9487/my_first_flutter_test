enum Electrochemical_Entity_Type {
  CA,
  CV,
  DPV,
}

abstract class Electrochemical_Entity {
  int get id;
  String get data_name;
  String get device_address;
  Electrochemical_Entity_Type get type;
  int get created_time;
  int get temperature;
  Iterable<int> get currents;
  Electrochemical_CA_Header? CA_header;
  Electrochemical_CV_Header? CV_header;
  Electrochemical_DPV_Header? DPV_header;
  @override
  bool operator ==(Object other) => identical(this, other)
      || (other is Electrochemical_Entity && other.id == id);
}

abstract class Electrochemical_CA_Header {
  int get E_dc;
  int get t_interval;
  int get t_run;
}

abstract class Electrochemical_CV_Header {
  int get E_begin;
  int get E_vertex1;
  int get E_vertex2;
  int get E_step;
  int get scan_rate;
  int get number_of_scans;
}

abstract class Electrochemical_DPV_Header {
  int get E_begin;
  int get E_end;
  int get E_step;
  int get E_pulse;
  int get t_pulse;
  int get scan_rate;
}