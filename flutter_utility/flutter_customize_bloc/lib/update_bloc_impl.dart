import 'package:flutter_customize_bloc/update_bloc.dart';

class UpdateBlocImpl extends UpdateBloc<UpdateEvent, UpdateState> {
  UpdateBlocImpl() : super(UpdateState()) {
    on<UpdateEvent>((event, emit) {
      emit(UpdateState());
    });
  }
  @override
  void update() {
    add(UpdateEvent());
  }
}

class UpdateEvent {
  @override
  bool operator ==(Object other) {
    return false;
  }
}

class UpdateState {
  @override
  bool operator ==(Object other) {
    return false;
  }
}