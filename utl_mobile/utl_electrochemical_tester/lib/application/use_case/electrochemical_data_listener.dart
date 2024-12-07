import 'dart:async';

import 'package:flutter_context_resource/context_resource.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_aggregate_handler.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';

abstract class Electrochemical_Data_Listener {
  Iterable<Electrochemical_UI_Data> get UI_data;
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_create(void Function(Electrochemical_UI_Data data) onCreate);
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_update(void Function(Electrochemical_UI_Data data) onUpdate);
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_finish(void Function(Electrochemical_UI_Data data) onFinish);
  StreamSubscription<Electrochemical_File_Data> on_file_data_finish(void Function(Electrochemical_File_Data data) onFinish);
}

class Electrochemical_Data_Listener_Impl implements Electrochemical_Data_Listener {
  Electrochemical_Data_Listener_Impl({
    required this.contextResource,
    required this.electrochemical_aggregate_handler,
    required this.electrochemical_file_data_factory,
    required this.electrochemical_ui_data_factory,
  }) {
    _onCreate = electrochemical_aggregate_handler.onCreate((entity) {
      _onCreateController.add(entity);
    });
    _onUpdate = electrochemical_aggregate_handler.onUpdate((entity) {
      _onUpdateController.add(entity);
    });
    _onFinish = electrochemical_aggregate_handler.onFinish((entity) {
      _onFinishController.add(entity);
    });
  }
  ContextResource contextResource;
  Electrochemical_Aggregate_Handler electrochemical_aggregate_handler;
  Electrochemical_File_Data_Factory electrochemical_file_data_factory;
  Electrochemical_UI_Data_Factory electrochemical_ui_data_factory;
  @override
  Iterable<Electrochemical_UI_Data> get UI_data => electrochemical_ui_data_factory.data;

  late final StreamSubscription<Electrochemical_Entity> _onCreate;
  late final StreamSubscription<Electrochemical_Entity> _onUpdate;
  late final StreamSubscription<Electrochemical_Entity> _onFinish;
  final StreamController<Electrochemical_Entity> _onCreateController = StreamController.broadcast();
  final StreamController<Electrochemical_Entity> _onUpdateController = StreamController.broadcast();
  final StreamController<Electrochemical_Entity> _onFinishController = StreamController.broadcast();

  @override
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_create(void Function(Electrochemical_UI_Data data) onCreate) {
    return _onCreateController.stream
        .map((event) => electrochemical_ui_data_factory.entity_to_data(event))
        .listen(onCreate);
  }
  @override
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_update(void Function(Electrochemical_UI_Data data) onUpdate) {
    return _onUpdateController.stream
        .map((event) => electrochemical_ui_data_factory.entity_to_data(event))
        .listen(onUpdate);
  }
  @override
  StreamSubscription<Electrochemical_UI_Data> on_UI_data_finish(void Function(Electrochemical_UI_Data data) onFinish) {
    return _onFinishController.stream
        .map((event) => electrochemical_ui_data_factory.entity_to_data(event))
        .listen(onFinish);
  }
  @override
  StreamSubscription<Electrochemical_File_Data> on_file_data_finish(void Function(Electrochemical_File_Data data) onFinish) {
    return _onFinishController.stream
        .map((event) => electrochemical_file_data_factory.entity_to_data(event))
        .listen(onFinish);
  }
}