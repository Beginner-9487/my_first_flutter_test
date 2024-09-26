import 'package:flutter_r/r.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';

class NullMackayIRBType extends MackayIRBType {
  @override
  int get id => 0x00;
  @override
  String get name => "";
}
class TemperatureMackayIRBType extends MackayIRBType {
  @override
  int get id => 0x01;
  @override
  String get name => R.str.temperature;
}
class CortisolMackayIRBType extends MackayIRBType {
  @override
  int get id => 0x02;
  @override
  String get name => R.str.cortisol;
}
class LactateMackayIRBType extends MackayIRBType {
  @override
  int get id => 0x03;
  @override
  String get name => R.str.lactate;
}
class DPVMackayIRBType extends MackayIRBType {
  @override
  int get id => 0x04;
  @override
  String get name => R.str.h1n1;
}