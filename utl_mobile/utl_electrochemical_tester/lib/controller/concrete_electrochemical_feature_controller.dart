import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/adapter/file/file_manager.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_feature_controller.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';

class ConcreteElectrochemicalFeatureController implements ElectrochemicalFeatureController {
  final ElectrochemicalEntityRepository electrochemicalEntityRepository;
  final FileManager fileManager;
  final String folderPath;
  ConcreteElectrochemicalFeatureController({
    required this.electrochemicalEntityRepository,
    required this.fileManager,
    required this.folderPath,
  });
  @override
  Future<bool> downloadFile({
    required AppLocalizations appLocalizations,
  }) {
    return fileManager.downloadAllElectrochemicalEntities(appLocalizations: appLocalizations, folderPath: folderPath);
  }
  @override
  Future<bool> clearRepository() {
    return electrochemicalEntityRepository.clearRepository();
  }
}
