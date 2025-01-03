import 'dart:async';
import 'dart:typed_data';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_received_packet.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';

abstract class ElectrochemicalSensorService {
  Iterable<ConcreteElectrochemicalSensor> get devices;
  sendBytes(Uint8List bytes);
  sendHexString(String string);
  Future startCa(CaSentPacket packet);
  Future startCv(CvSentPacket packet);
  Future startDpv(DpvSentPacket packet);
}

ElectrochemicalParameters? electrochemicalParametersBuffer;

class ConcreteElectrochemicalSensorService implements ElectrochemicalSensorService {
  ElectrochemicalDataService electrochemicalDataService;
  UtlBluetoothHandler<ConcreteElectrochemicalSensor> handler;
  @override
  Iterable<ConcreteElectrochemicalSensor> get devices => handler.devices;
  ConcreteElectrochemicalSensorService({
    required this.handler,
    required this.electrochemicalDataService,
  }) {
    _onReceivePacket = handler.onReceivePacket.listen((packet) {
      if(electrochemicalParametersBuffer == null) {
        return;
      }
      if(HeaderReceivedPacket.check(packet.data)) {
        HeaderReceivedPacket p = HeaderReceivedPacket.getByUtlPacket(packet);
        electrochemicalDataService.create(ElectrochemicalHeader(
          dataName: devices.where((device) => device.deviceId == p.deviceId).first.dataName,
          deviceId: p.deviceId,
          createdTime: DateTime.now().microsecondsSinceEpoch,
          temperature: p.temperature,
          parameters: electrochemicalParametersBuffer!,
        ));
      }
      if(DataReceivedPacket.check(packet.data)) {
        DataReceivedPacket p = DataReceivedPacket.getByUtlPacket(packet);
        ElectrochemicalEntity? entity = electrochemicalDataService.latestEntities.lastOrNull;
        if(entity == null) return;
        electrochemicalDataService.update(
            entity,
            ElectrochemicalData(
              index: p.index,
              time: p.time,
              voltage: p.voltage,
              current: p.current,
            ),
        );
      }
    });
  }
  @override
  sendBytes(Uint8List bytes) {
    handler.sendBytes(bytes);
  }
  @override
  sendHexString(String string) {
    handler.sendHexString(string);
  }
  late final StreamSubscription<UtlReceivedBluetoothPacket> _onReceivePacket;

  @override
  Future startCa(CaSentPacket packet) async {
    electrochemicalParametersBuffer = packet.electrochemicalParameters;
    sendBytes(packet.data);
  }

  @override
  Future startCv(CvSentPacket packet) async {
    electrochemicalParametersBuffer = packet.electrochemicalParameters;
    sendBytes(packet.data);
  }

  @override
  Future startDpv(DpvSentPacket packet) async {
    electrochemicalParametersBuffer = packet.electrochemicalParameters;
    sendBytes(packet.data);
  }
}