import 'dart:async';

import 'package:utl_electrochemical_tester/application/repository/electrochemical_file_repository.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data_listener.dart';

abstract class Save_File_While_Finish {}

class Save_File_While_Finish_Impl implements Save_File_While_Finish {
  Save_File_While_Finish_Impl({
    required this.electrochemical_data_listener,
    required this.electrochemical_file_repository
  }) {
    onFinish = electrochemical_data_listener.on_file_data_finish((entity) async {
      electrochemical_file_repository.saveElectrochemicalFile(entity);
      electrochemical_file_repository.saveYiQinFile(entity);
    });
  }
  final Electrochemical_Data_Listener electrochemical_data_listener;
  final Electrochemical_File_Repository electrochemical_file_repository;
  late final StreamSubscription<Electrochemical_File_Data> onFinish;
}