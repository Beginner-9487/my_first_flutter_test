import 'dart:ui';

import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/color/dataset_color_generator_impl.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_aggregate_handler.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data_impl.dart';

String _get_type_string(ContextResource contextResource, Electrochemical_Entity_Type type) {
  switch (type) {
    case Electrochemical_Entity_Type.CA:
      return contextResource.str.ca;
    case Electrochemical_Entity_Type.CV:
      return contextResource.str.cv;
    case Electrochemical_Entity_Type.DPV:
      return contextResource.str.dpv;
  }
}

int _get_voltage(Electrochemical_Entity entity, int index) {
  switch(entity.type) {
    case Electrochemical_Entity_Type.CA:
      Electrochemical_CA_Header header = entity.CA_header!;
      return header.E_dc;
    case Electrochemical_Entity_Type.CV:
      Electrochemical_CV_Header header = entity.CV_header!;
      return header.E_begin;
    case Electrochemical_Entity_Type.DPV:
      Electrochemical_DPV_Header header = entity.DPV_header!;
      return header.E_begin + ((header.E_step * index) / 2).floor() + ((index % 2 == 1) ? header.E_pulse : 0);
  }
}

int _get_time_since_created(Electrochemical_Entity entity, int index) {
  switch(entity.type) {
    case Electrochemical_Entity_Type.CA:
      Electrochemical_CA_Header header = entity.CA_header!;
      return header.t_interval * index * 1000;
    case Electrochemical_Entity_Type.CV:
      Electrochemical_CV_Header header = entity.CV_header!;
      if(header.scan_rate == 0) {
        return 0;
      }
      return (((header.E_step / header.scan_rate) / 2) * index * 1E6).toInt();
    case Electrochemical_Entity_Type.DPV:
      Electrochemical_DPV_Header header = entity.DPV_header!;
      if(header.scan_rate == 0) {
        return 0;
      }
      return (((header.E_step / header.scan_rate) / 2) * index * 1E6).toInt();
  }
}

class Electrochemical_UI_Data_Factory_Impl implements Electrochemical_UI_Data_Factory {
  Electrochemical_UI_Data_Factory_Impl(
      this.contextResource,
      this.electrochemical_aggregate_handler,
  );
  ContextResource contextResource;
  Electrochemical_Aggregate_Handler electrochemical_aggregate_handler;
  static final DatasetColorGeneratorImpl colorGenerator = DatasetColorGeneratorImpl();
  Iterable<Electrochemical_Entity> get entities => electrochemical_aggregate_handler
      .aggregate
      .entities;
  @override
  Iterable<Electrochemical_UI_Data> get data => entities
      .map((e) => entity_to_data(e));
  @override
  Electrochemical_UI_Data entity_to_data(Electrochemical_Entity entity) {
    return Electrochemical_UI_Data_Impl(
      entity: entity,
      typeString: _get_type_string(contextResource, entity.type),
      color: _get_color(entity),
      points: _get_UI_point(entity),
      temperature: entity.temperature / 1000000.0,
    );
  }
  Iterable<Electrochemical_UI_Data_Point> _get_UI_point(Electrochemical_Entity entity) {
    return entity.currents.indexed.map((current) => Electrochemical_UI_Data_Point_Impl(
      current: current.$2 / 1000000,
      time_since_created: Duration(microseconds: _get_time_since_created(entity, current.$1)),
      voltage: _get_voltage(entity, current.$1) / 1000,
    ));
  }
  Color _get_color(Electrochemical_Entity entity) {
    int index = entities
        .where((element) => element.type == entity.type)
        .indexed
        .where((element) => element.$2 == entity)
        .first
        .$1;
    int arrayIndex;
    switch(entity.type) {
      case Electrochemical_Entity_Type.CA:
        arrayIndex = 0;
        break;
      case Electrochemical_Entity_Type.CV:
        arrayIndex = 1;
        break;
      case Electrochemical_Entity_Type.DPV:
        arrayIndex = 2;
        break;
    }
    return colorGenerator.rainbowLayer(
      alpha: 0.75,
      index: index + 11,
      length: entities.length + 10,
      arrayIndex: arrayIndex,
      arrayLength: 2,
    );
  }
}

class Electrochemical_File_Data_Factory_Impl implements Electrochemical_File_Data_Factory {
  Electrochemical_File_Data_Factory_Impl(
      this.contextResource,
      this.electrochemical_aggregate_handler,
  );
  ContextResource contextResource;
  Electrochemical_Aggregate_Handler electrochemical_aggregate_handler;
  Iterable<Electrochemical_Entity> get entities => electrochemical_aggregate_handler
      .aggregate
      .entities;
  @override
  Iterable<Electrochemical_File_Data> get data => entities
      .map((e) => entity_to_data(e));
  @override
  Electrochemical_File_Data entity_to_data(Electrochemical_Entity entity) {
    return Electrochemical_File_Data_Impl(
      entity: entity,
      typeString: _get_type_string(contextResource, entity.type),
      points: _get_File_point(entity),
    );
  }
  Iterable<Electrochemical_File_Data_Point> _get_File_point(Electrochemical_Entity entity) {
    return entity.currents.indexed.map((current) => Electrochemical_File_Data_Point_Impl(
      current: current.$2,
      time_since_created: _get_time_since_created(entity, current.$1),
      voltage: _get_voltage(entity, current.$1),
    ));
  }
}