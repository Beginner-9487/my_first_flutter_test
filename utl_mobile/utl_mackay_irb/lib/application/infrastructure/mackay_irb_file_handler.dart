import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';

abstract class MackayIRBFileHandler {
  Future saveMeasurementFile(MackayIRBEntity entity);
  Future save5sFile(MackayIRBEntity entity);
}