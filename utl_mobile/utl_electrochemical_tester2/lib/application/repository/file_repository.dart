import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';

abstract class FileRepository {
  Future<bool> createFile();
  Future<bool> writeFile(Iterable<ElectrochemicalDataEntity> entities);
}
