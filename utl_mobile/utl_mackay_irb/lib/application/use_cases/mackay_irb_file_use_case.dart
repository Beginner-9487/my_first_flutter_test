import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler.dart';

class MackayIRBFileUseCase {
  MackayIRBFileUseCase();
  saveMeasurementFile(MackayIRBEntity entity) async {
    MackayIRBFileHandler.saveMeasurementFile(entity);
  }
  save5sFile(MackayIRBEntity entity) async {
    MackayIRBFileHandler.save5sFile(entity);
  }
}