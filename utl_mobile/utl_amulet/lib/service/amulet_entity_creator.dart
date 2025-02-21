import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:utl_amulet/adapter/amulet_device/amulet_devices_manager.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';

import '../adapter/adapter_dto_mapper.dart';

abstract class AmuletEntityCreatorIsCreatingChangeNotifier extends ChangeNotifier {
  bool get isCreating;
}

abstract class AmuletEntityCreator {
  bool get isCreating;
  AmuletEntityCreatorIsCreatingChangeNotifier createChangeNotifier();
  void startCreating();
  void stopCreating();
  void toggleCreating();
}

class ConcreteAmuletEntityCreatorIsCreatingChangeNotifier extends AmuletEntityCreatorIsCreatingChangeNotifier {
  ConcreteAmuletEntityCreator creator;

  ConcreteAmuletEntityCreatorIsCreatingChangeNotifier({
    required this.creator,
  }) {
    creator._notifiers.add(this);
  }

  @override
  bool get isCreating => creator.isCreating;

  @override
  void notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    creator._notifiers.remove(this);
    super.dispose();
  }
}

class ConcreteAmuletEntityCreator implements AmuletEntityCreator {
  final AmuletRepository amuletRepository;
  final AmuletDevicesManager amuletDevicesManager;
  final List<ConcreteAmuletEntityCreatorIsCreatingChangeNotifier> _notifiers = [];
  late final StreamSubscription _subscription;
  bool _isCreating = false;

  void dispose() {
    _subscription.cancel();
    for(var notifier in _notifiers) {
      notifier.dispose();
    }
    _notifiers.clear();
  }

  ConcreteAmuletEntityCreator({
    required this.amuletRepository,
    required this.amuletDevicesManager,
  }) {
    _subscription = amuletDevicesManager.dataStream.listen((data) {
      if(!_isCreating) return;
      final dto = AdapterDtoMapper.mapDeviceDataDtoToRepositoryInsertDto(dto: data);
      amuletRepository.insert(dto: dto);
    });
  }

  @override
  bool get isCreating => _isCreating;

  @override
  void startCreating() {
    _isCreating = true;
    notifyListeners();
  }

  @override
  void stopCreating() {
    _isCreating = false;
    notifyListeners();
  }

  @override
  void toggleCreating() {
    return (isCreating)
      ? stopCreating()
      : startCreating();
  }

  void notifyListeners() {
    for(var notifier in _notifiers) {
      notifier.notifyListeners();
    }
  }

  @override
  AmuletEntityCreatorIsCreatingChangeNotifier createChangeNotifier() {
    return ConcreteAmuletEntityCreatorIsCreatingChangeNotifier(creator: this);
  }
}
