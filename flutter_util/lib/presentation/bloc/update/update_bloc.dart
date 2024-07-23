import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {

  int? lineChartX = 0;

  UpdateBloc() : super(initialState) {
    on<UpdateEvent>((event, emit) {
      _refreshUI();
    });
  }

  @override
  static UpdateState get initialState => UpdateState();

  _refreshUI() {
    emit(UpdateState());
  }
}

class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object?> get props => [];
}

class UpdateState extends Equatable {
  static bool b = false;

  @override
  List<bool> get props {
    b = !b;
    return [b];
  }
}