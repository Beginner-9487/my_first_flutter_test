import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/adapter/file/file_manager.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/infrastructure/source/csv_file/csv_electrochemical_file.dart';

class ConcreteFileManager implements FileManager {

  String amuletFileDownloadFolder;

  ConcreteFileManager({
    required this.amuletFileDownloadFolder,
  });

  @override
  Future<bool> downloadAmuletEntitiesFile({
    required AppLocalizations appLocalizations,
    required Stream<AmuletEntity> fetchEntitiesStream,
  }) async {
    final file = CsvAmuletFile(
      folderPath: amuletFileDownloadFolder,
    );
    await file.clearThenGenerateHeader(appLocalizations: appLocalizations);
    await for(var entity in fetchEntitiesStream) {
      if(!(await file.writeEntities(entities: [entity]))) return false;
    }
    return true;
  }

}
