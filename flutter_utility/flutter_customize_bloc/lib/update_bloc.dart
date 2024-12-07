import 'package:bloc/bloc.dart';

abstract class UpdateBloc<Event, State> extends Bloc<Event, State> {
  UpdateBloc(super.initialState);
  void update();
}