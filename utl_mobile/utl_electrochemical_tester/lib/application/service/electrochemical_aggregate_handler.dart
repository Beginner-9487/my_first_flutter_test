import 'dart:async';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_aggregate.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity_impl.dart';
import 'package:utl_mobile/utl_domain/utl_domain.dart';

abstract class Electrochemical_Aggregate_Handler {
  Electrochemical_Aggregate get aggregate;
  void createCA(String data_name, String device_address, UTL_Data_CA_Header header);
  void createCV(String data_name, String device_address, UTL_Data_CV_Header header);
  void createDPV(String data_name, String device_address, UTL_Data_DPV_Header header);
  void addCurrent(String data_name, String device_address, UTL_Data_Currents currents);
  StreamSubscription<Electrochemical_Entity> onCreate(void Function(Electrochemical_Entity entity) onCreate);
  StreamSubscription<Electrochemical_Entity> onUpdate(void Function(Electrochemical_Entity entity) onUpdate);
  StreamSubscription<Electrochemical_Entity> onFinish(void Function(Electrochemical_Entity entity) onFinish);
}

class Electrochemical_Aggregate_Handler_Impl implements Electrochemical_Aggregate_Handler {
  Electrochemical_Aggregate_Handler_Impl({
    required this.aggregate,
  });
  @override
  Electrochemical_Aggregate_Impl aggregate;
  bool isFinished(Electrochemical_Entity entity) {
    switch(entity.type) {
      case Electrochemical_Entity_Type.CA:
        Electrochemical_CA_Header header = entity.CA_header!;
        return entity.currents.length >= (header.t_run / header.t_interval).floor();
      case Electrochemical_Entity_Type.CV:
        Electrochemical_CV_Header header = entity.CV_header!;
        return entity.currents.length >= ((((header.E_vertex1 - header.E_begin).abs() + (header.E_vertex2 - header.E_vertex1).abs() + (header.E_vertex2 - header.E_begin).abs()) * header.number_of_scans / header.E_step) + 1).floor();
      case Electrochemical_Entity_Type.DPV:
        Electrochemical_DPV_Header header = entity.DPV_header!;
        return entity.currents.length >= (((header.E_end - header.E_begin).abs() / header.E_step) * 2).floor();
    }
  }
  @override
  void createCA(String data_name, String device_address, UTL_Data_CA_Header header) {
    final entity = Electrochemical_Entity_Impl(
      data_name: data_name,
      device_address: device_address,
      type: Electrochemical_Entity_Type.CA,
      temperature: header.temperature,
      CA_header: Electrochemical_CA_Header_Impl(
        E_dc: header.E_dc,
        t_interval: header.t_interval,
        t_run: header.t_run,
      ),
    );
    aggregate.entities.add(entity);
    _onCreateController.add(entity);
  }
  @override
  void createCV(String data_name, String device_address, UTL_Data_CV_Header header) {
    final entity = Electrochemical_Entity_Impl(
      data_name: data_name,
      device_address: device_address,
      type: Electrochemical_Entity_Type.CV,
      temperature: header.temperature,
      CV_header: Electrochemical_CV_Header_Impl(
        E_begin: header.E_begin,
        E_vertex1: header.E_vertex1,
        E_vertex2: header.E_vertex2,
        E_step: header.E_step,
        scan_rate: header.scan_rate,
        number_of_scans: header.number_of_scans,
      ),
    );
    aggregate.entities.add(entity);
    _onCreateController.add(entity);
  }
  @override
  void createDPV(String data_name, String device_address, UTL_Data_DPV_Header header) {
    final entity = Electrochemical_Entity_Impl(
      data_name: data_name,
      device_address: device_address,
      type: Electrochemical_Entity_Type.DPV,
      temperature: header.temperature,
      DPV_header: Electrochemical_DPV_Header_Impl(
        E_begin: header.E_begin,
        E_end: header.E_end,
        E_step: header.E_step,
        E_pulse: header.E_pulse,
        t_pulse: header.t_pulse,
        scan_rate: header.scan_rate,
      ),
    );
    aggregate.entities.add(entity);
    _onCreateController.add(entity);
  }
  @override
  void addCurrent(String data_name, String device_address, UTL_Data_Currents currents) {
    Electrochemical_Entity_Impl? entity = aggregate
        .entities
        .where((element) => element.data_name == data_name && element.device_address == device_address)
        .lastOrNull;
    if(entity == null) {
      return;
    }
    entity.currents.addAll(currents.currents);
    _onUpdateController.add(entity);
    if(isFinished(entity)) {
      _onFinishController.add(entity);
    }
  }
  final StreamController<Electrochemical_Entity> _onCreateController = StreamController.broadcast();
  @override
  StreamSubscription<Electrochemical_Entity> onCreate(void Function(Electrochemical_Entity entity) onCreate) {
    return _onCreateController.stream.listen(onCreate);
  }
  final StreamController<Electrochemical_Entity> _onUpdateController = StreamController.broadcast();
  @override
  StreamSubscription<Electrochemical_Entity> onUpdate(void Function(Electrochemical_Entity entity) onUpdate) {
    return _onUpdateController.stream.listen(onUpdate);
  }
  final StreamController<Electrochemical_Entity> _onFinishController = StreamController.broadcast();
  @override
  StreamSubscription<Electrochemical_Entity> onFinish(void Function(Electrochemical_Entity entity) onFinish) {
    return _onFinishController.stream.listen(onFinish);
  }
}