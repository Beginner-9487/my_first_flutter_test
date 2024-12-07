import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity_impl.dart';

abstract class Electrochemical_Aggregate {
  Iterable<Electrochemical_Entity> get entities;
}

class Electrochemical_Aggregate_Impl implements Electrochemical_Aggregate {
  @override
  List<Electrochemical_Entity_Impl> entities = [];
}