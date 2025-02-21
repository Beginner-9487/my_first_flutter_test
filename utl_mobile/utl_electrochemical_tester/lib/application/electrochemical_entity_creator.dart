import 'dart:async';

import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/application/application_dto_mapper.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';

class ElectrochemicalEntityCreator {
  late final StreamSubscription<ElectrochemicalDeviceReceivedHeaderDto> headerStream;
  late final StreamSubscription<ElectrochemicalDeviceReceivedDataDto> dataStream;
  final ElectrochemicalEntityRepository electrochemicalEntityRepository;
  bool _isStarting = false;
  ElectrochemicalEntityCreator({
    required this.electrochemicalEntityRepository,
    required ElectrochemicalDevicesManager electrochemicalDevicesManager,
  }) {
    headerStream = electrochemicalDevicesManager.headerStream.listen((dto) {
      if(!_isStarting) return;
      electrochemicalEntityRepository.createEntityFromHeader(header: ApplicationDtoMapper.mapDtoToHeader(dto: dto));
    });
    dataStream = electrochemicalDevicesManager.dataStream.listen((dto) {
      if(!_isStarting) return;
      electrochemicalEntityRepository.appendDataToEntity(entityId: dto.entityId, data: [ApplicationDtoMapper.mapDtoToData(dto: dto)]);
    });
  }
  void start() {
    _isStarting = true;
  }
  void stop() {
    _isStarting = false;
  }
  void dispose() {
    headerStream.cancel();
    dataStream.cancel();
  }
}
