import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler_impl.dart';

class MackayIRBFileUseCase {
  late final MackayIRBFileHandler mackayIRBFileHandler;
  MackayIRBFileUseCase() {
    mackayIRBFileHandler = MackayIRBFileHandlerImpl.getInstance();
  }
  saveMeasurementFile(MackayIRBEntity entity) async {
    mackayIRBFileHandler.saveMeasurementFile(entity);
  }
  save5sFile(MackayIRBEntity entity) async {
    mackayIRBFileHandler.save5sFile(entity);
  }
}