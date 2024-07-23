import 'package:file_picker/file_picker.dart';
import 'package:flutter_util/path.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/infrastructure/amulet_file_handler.dart';

class ReadFileUseCase {
  final AmuletRepository _amuletRepository;
  ReadFileUseCase(this._amuletRepository);

  Future<bool> readAmuletFile() async {
    // var result = await FilePicker.platform.pickFiles(
    //   initialDirectory: await Path.systemDownloadPath,
    // );
    // if(result == null || result!.paths.isEmpty) {
    //   return false;
    // }
    // try {
    //   await AmuletFileHandler(_amuletRepository).readFile(result!.paths.first!);
    // } catch(e) {
    //   return false;
    // }
    return true;
  }
}