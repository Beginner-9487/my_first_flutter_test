import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/adapter/amulet_device/amulet_devices_manager.dart';
import 'package:utl_amulet/adapter/file/file_manager.dart';
import 'package:utl_amulet/controller/amulet_buttons_board_controller.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';
import 'package:utl_amulet/service/amulet_entity_creator.dart';

class ConcreteAmuletButtonsBoardIsSavingChangeNotifier extends ConcreteAmuletEntityCreatorIsCreatingChangeNotifier implements AmuletButtonsBoardIsSavingChangeNotifier {
  ConcreteAmuletButtonsBoardIsSavingChangeNotifier({required super.creator});
  @override
  bool get isSaving => super.isCreating;
}

class ConcreteAmuletButtonsBoardController implements AmuletButtonsBoardController {
  final AmuletDevicesManager amuletDevicesManager;
  final ConcreteAmuletEntityCreator concreteAmuletEntityCreator;
  final AmuletRepository amuletRepository;
  final FileManager fileManager;

  ConcreteAmuletButtonsBoardController({
    required this.amuletDevicesManager,
    required this.concreteAmuletEntityCreator,
    required this.amuletRepository,
    required this.fileManager,
  });

  @override
  void clearBuffer() async {
    amuletDevicesManager.clearBuffer();
    await amuletRepository.clear();
    return;
  }

  @override
  Future<bool> downloadFile({required AppLocalizations appLocalizations}) {
    return fileManager.downloadAmuletEntitiesFile(
      appLocalizations: appLocalizations,
      fetchEntitiesStream: amuletRepository.fetchEntities(),
    );
  }

  @override
  void toggleSavingStage() {
    return concreteAmuletEntityCreator.toggleCreating();
  }

  @override
  AmuletButtonsBoardIsSavingChangeNotifier createIsSavingChangeNotifier() {
    return ConcreteAmuletButtonsBoardIsSavingChangeNotifier(creator: concreteAmuletEntityCreator);
  }

}
