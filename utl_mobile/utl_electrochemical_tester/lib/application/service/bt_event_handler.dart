import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bt/bt.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_aggregate_handler.dart';
import 'package:utl_electrochemical_tester/resources/command.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bt_handler.dart';
import 'package:utl_mobile/utl_data_converter/utl_bytes_to_data.dart';
import 'package:utl_mobile/utl_data_converter/utl_data_to_bytes.dart';
import 'package:utl_mobile/utl_domain/utl_domain.dart';

abstract class BT_Event_Handler {
  void setName(BT_Device device, String name);
  String getName(BT_Device device);
  Future connect(BT_Device device);
  Future disconnect(BT_Device device);
  Future startCA(BT_Device device, UTL_Data_CA_Command utl_data_ca_command);
  Future startCV(BT_Device device, UTL_Data_CV_Command utl_data_cv_command);
  Future startDPV(BT_Device device, UTL_Data_DPV_Command utl_data_dpv_command);
  Future startHumanTrials(BT_Device device);
  Future startVirusDetector(BT_Device device);
  BT_Provider get bt_provider;
}

class BT_Event_Handler_Impl implements BT_Event_Handler {
  BT_Event_Handler_Impl({
    required this.electrochemical_aggregate_handler,
    required this.utl_bytes_to_data,
    required this.utl_bt_handler,
    required this.utl_data_to_bytes,
  }) {
    onReceivePacket = utl_bt_handler.onReceivePacket((packet) {
      debugPrint("BT_Event_Handler_Impl: onReceivedPacket: ${packet.bytes}");
      _Buffer? buffer = _buffers.where((element) => element.device_address == packet.device.address).firstOrNull;
      if(buffer == null) {
        return;
      }
      Iterable<dynamic> data = utl_bytes_to_data.convert(packet.bytes);
      debugPrint("BT_Event_Handler_Impl: data.length: ${data.length}");
      for(var element in data) {
        if(element is UTL_Data_CA_Header) {
          debugPrint("BT_Event_Handler_Impl: UTL_Data_CA_Header}");
          electrochemical_aggregate_handler.createCA(buffer.data_name, buffer.device_address, element);
        }
        if(element is UTL_Data_CV_Header) {
          debugPrint("BT_Event_Handler_Impl: UTL_Data_CV_Header}");
          electrochemical_aggregate_handler.createCV(buffer.data_name, buffer.device_address, element);
        }
        if(element is UTL_Data_DPV_Header) {
          debugPrint("BT_Event_Handler_Impl: UTL_Data_DPV_Header}");
          electrochemical_aggregate_handler.createDPV(buffer.data_name, buffer.device_address, element);
        }
        if(element is UTL_Data_Currents) {
          debugPrint("BT_Event_Handler_Impl: UTL_Data_Currents}");
          electrochemical_aggregate_handler.addCurrent(buffer.data_name, buffer.device_address, element);
        }
      }
    });
  }
  final Electrochemical_Aggregate_Handler electrochemical_aggregate_handler;
  final UTL_Bytes_to_Data utl_bytes_to_data;
  final UTL_BT_Handler utl_bt_handler;
  final UTL_Data_To_Bytes utl_data_to_bytes;
  final List<_Buffer> _buffers = [];
  late final StreamSubscription<BT_Packet_Characteristic> onReceivePacket;
  @override
  BT_Provider get bt_provider => utl_bt_handler.bt_provider;
  @override
  String getName(BT_Device device) {
    _Buffer? buffer = _buffers.where((element) => element.device_address == device.address).firstOrNull;
    return (buffer != null) ? buffer.data_name : "";
  }

  @override
  void setName(BT_Device device, String name) {
    _Buffer? buffer = _buffers.where((element) => element.device_address == device.address).firstOrNull;
    if(buffer == null) {
      buffer = _Buffer(
        data_name: name,
        device_address: device.address,
      );
      _buffers.add(buffer);
    } else {
      buffer.data_name = name;
    }
  }

  @override
  Future connect(BT_Device device) {
    return utl_bt_handler.connect(device);
  }

  @override
  Future disconnect(BT_Device device) {
    return utl_bt_handler.disconnect(device);
  }

  @override
  Future startCA(BT_Device device, UTL_Data_CA_Command utl_data_ca_command) {
    return utl_bt_handler.sendBytes(utl_data_to_bytes.convert([utl_data_ca_command]));
  }

  @override
  Future startCV(BT_Device device, UTL_Data_CV_Command utl_data_cv_command) {
    return utl_bt_handler.sendBytes(utl_data_to_bytes.convert([utl_data_cv_command]));
  }

  @override
  Future startDPV(BT_Device device, UTL_Data_DPV_Command utl_data_dpv_command) {
    return utl_bt_handler.sendBytes(utl_data_to_bytes.convert([utl_data_dpv_command]));
  }

  @override
  Future startHumanTrials(BT_Device device) {
    return utl_bt_handler.sendBytes(START_HUMAN_TRIALS_COMMAND);
  }

  @override
  Future startVirusDetector(BT_Device device) {
    return utl_bt_handler.sendBytes(START_DPV_COMMAND);
  }
}

class _Buffer {
  String data_name;
  String device_address;
  _Buffer({
    required this.data_name,
    required this.device_address,
  });
}
