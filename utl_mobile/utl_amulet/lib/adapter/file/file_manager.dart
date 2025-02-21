import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';

abstract class FileManager {
  Future<bool> downloadAmuletEntitiesFile({
    required AppLocalizations appLocalizations,
    required Stream<AmuletEntity> fetchEntitiesStream,
  });
}
