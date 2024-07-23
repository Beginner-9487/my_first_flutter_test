import 'package:utl_amulet/application/domain/amulet_repository.dart';

abstract class AmuletFileHandler {
  readFile(String filePath);
  addDataToFile(AmuletRow row);
}