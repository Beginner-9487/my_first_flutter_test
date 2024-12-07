abstract class UTL_Data_Currents {
  Iterable<int> get currents;
}

abstract class UTL_Data_CA_Header {
  int get temperature;
  int get E_dc;
  int get t_interval;
  int get t_run;
}

abstract class UTL_Data_CV_Header {
  int get temperature;
  int get E_begin;
  int get E_vertex1;
  int get E_vertex2;
  int get E_step;
  int get scan_rate;
  int get number_of_scans;
}

abstract class UTL_Data_DPV_Header {
  int get temperature;
  int get E_begin;
  int get E_end;
  int get E_step;
  int get E_pulse;
  int get t_pulse;
  int get scan_rate;
}

abstract class UTL_Data_CA_Command {
  int get E_dc;
  int get t_interval;
  int get t_run;
}

abstract class UTL_Data_CV_Command {
  int get E_begin;
  int get E_vertex1;
  int get E_vertex2;
  int get E_step;
  int get scan_rate;
  int get number_of_scans;
}

abstract class UTL_Data_DPV_Command {
  int get E_begin;
  int get E_end;
  int get E_step;
  int get E_pulse;
  int get t_pulse;
  int get scan_rate;
}

class UTL_Data_Currents_Impl implements UTL_Data_Currents {
  @override
  List<int> currents;
  UTL_Data_Currents_Impl({
    required this.currents,
  });
}

class UTL_Data_CA_Header_Impl implements UTL_Data_CA_Header {
  @override
  int temperature;
  @override
  int E_dc;
  @override
  int t_interval;
  @override
  int t_run;
  UTL_Data_CA_Header_Impl({
    required this.temperature,
    required this.E_dc,
    required this.t_interval,
    required this.t_run,
  });
}

class UTL_Data_CV_Header_Impl implements UTL_Data_CV_Header {
  @override
  int temperature;
  @override
  int E_begin;
  @override
  int E_vertex1;
  @override
  int E_vertex2;
  @override
  int E_step;
  @override
  int scan_rate;
  @override
  int number_of_scans;

  UTL_Data_CV_Header_Impl({
    required this.temperature,
    required this.E_begin,
    required this.E_vertex1,
    required this.E_vertex2,
    required this.E_step,
    required this.scan_rate,
    required this.number_of_scans,
  });
}

class UTL_Data_DPV_Header_Impl implements UTL_Data_DPV_Header {
  @override
  int temperature;
  @override
  int E_begin;
  @override
  int E_end;
  @override
  int E_step;
  @override
  int E_pulse;
  @override
  int t_pulse;
  @override
  int scan_rate;
  UTL_Data_DPV_Header_Impl({
    required this.temperature,
    required this.E_begin,
    required this.E_end,
    required this.E_step,
    required this.E_pulse,
    required this.t_pulse,
    required this.scan_rate,
  });
}

class UTL_Data_CA_Command_Impl implements UTL_Data_CA_Command {
  @override
  int E_dc;
  @override
  int t_interval;
  @override
  int t_run;
  UTL_Data_CA_Command_Impl({
    required this.E_dc,
    required this.t_interval,
    required this.t_run,
  });
}

class UTL_Data_CV_Command_Impl implements UTL_Data_CV_Command {
  @override
  int E_begin;
  @override
  int E_vertex1;
  @override
  int E_vertex2;
  @override
  int E_step;
  @override
  int scan_rate;
  @override
  int number_of_scans;

  UTL_Data_CV_Command_Impl({
    required this.E_begin,
    required this.E_vertex1,
    required this.E_vertex2,
    required this.E_step,
    required this.scan_rate,
    required this.number_of_scans,
  });
}

class UTL_Data_DPV_Command_Impl implements UTL_Data_DPV_Command {
  @override
  int E_begin;
  @override
  int E_end;
  @override
  int E_step;
  @override
  int E_pulse;
  @override
  int t_pulse;
  @override
  int scan_rate;
  UTL_Data_DPV_Command_Impl({
    required this.E_begin,
    required this.E_end,
    required this.E_step,
    required this.E_pulse,
    required this.t_pulse,
    required this.scan_rate,
  });
}
