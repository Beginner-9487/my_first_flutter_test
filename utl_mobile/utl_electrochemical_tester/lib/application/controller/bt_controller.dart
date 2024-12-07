import 'dart:async';

import 'package:flutter_bt/bt.dart';
import 'package:utl_electrochemical_tester/application/service/bt_event_handler.dart';
import 'package:utl_mobile/utl_domain/utl_domain.dart';

abstract class BT_Controller {
  Future connect(BT_Device device);
  Future disconnect(BT_Device device);
  Future startCA(BT_Device device, UTL_Data_CA_Command utl_data_ca_command);
  Future startCV(BT_Device device, UTL_Data_CV_Command utl_data_cv_command);
  Future startDPV(BT_Device device, UTL_Data_DPV_Command utl_data_dpv_command);
  Future startHumanTrials(BT_Device device);
  Future startVirusDetector(BT_Device device);
  void setName(BT_Device device, String name);
  String getName(BT_Device device);
  BT_Provider get bt_provider;
}

class BT_Controller_Impl implements BT_Controller {
  BT_Controller_Impl({
    required this.bt_event_handler,
  });
  BT_Event_Handler bt_event_handler;
  @override
  BT_Provider get bt_provider => bt_event_handler.bt_provider;

  @override
  Future connect(BT_Device device) {
    return bt_event_handler.connect(device);
  }

  @override
  Future disconnect(BT_Device device) {
    return bt_event_handler.disconnect(device);
  }

  @override
  String getName(BT_Device device) {
    return bt_event_handler.getName(device);
  }

  @override
  void setName(BT_Device device, String name) {
    bt_event_handler.setName(device, name);
  }

  @override
  Future startHumanTrials(BT_Device device) {
    return bt_event_handler.startHumanTrials(device);
  }

  @override
  Future startVirusDetector(BT_Device device) {
    return bt_event_handler.startVirusDetector(device);
  }

  @override
  Future startCA(BT_Device device, UTL_Data_CA_Command utl_data_ca_command) {
    return bt_event_handler.startCA(device, utl_data_ca_command);
  }

  @override
  Future startCV(BT_Device device, UTL_Data_CV_Command utl_data_cv_command) {
    return bt_event_handler.startCV(device, utl_data_cv_command);
  }

  @override
  Future startDPV(BT_Device device, UTL_Data_DPV_Command utl_data_dpv_command) {
    return bt_event_handler.startDPV(device, utl_data_dpv_command);
  }
}