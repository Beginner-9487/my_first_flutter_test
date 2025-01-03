import 'package:utl_electrochemical_tester/application/dto/electrochemical_file_dto.dart';

abstract class FileRepository {
  Future<bool> createFile();
  Future<bool> writeFile(Iterable<ElectrochemicalFileDto> dto);
}
