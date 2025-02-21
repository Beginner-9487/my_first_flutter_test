import 'package:flutter/cupertino.dart';
import 'package:utl_electrochemical_tester/adapter/file/file_manager.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/domain/usecase/process_electrochemical_entities_usecase.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/csv_file/csv_electrochemical_file.dart';

class ConcreteFileManager implements FileManager {
  ElectrochemicalEntityRepository electrochemicalEntityRepository;
  ConcreteFileManager({
    required this.electrochemicalEntityRepository,
  });
  Future<bool> downloadAllElectrochemicalEntities({
    required AppLocalizations appLocalizations,
    required String folderPath,
  }) async {
    var usecase = ProcessElectrochemicalEntitiesUsecase(
      electrochemicalEntityRepository: electrochemicalEntityRepository,
    );
    var file = CsvElectrochemicalFile(folderPath: folderPath);
    if(!(await file.clearThenGenerateHeader(appLocalizations: appLocalizations))) return false;
    bool flag = true;
    usecase(
      processor: (entity) {
        debugPrint("downloadAllElectrochemicalEntities: $entity");
        if(entity == null) return true;
        file.writeEntities(
          entities: [
            entity,
          ],
        ).then((value) {
          flag = value;
        });
        return flag;
      }
    );
    return flag;
  }
}
