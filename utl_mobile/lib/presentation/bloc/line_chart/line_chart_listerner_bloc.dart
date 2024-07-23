import 'package:bloc/bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_event.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listener_state.dart';

class LineChartListenerBloc extends Bloc<LineChartEvent, LineChartState> {

  int? xIndex;
  bool onTouched = false;

  LineChartListenerBloc() : super(initialState) {
    on<LineChartEventError>((event, emit) {
      _refreshUI();
    });
    on<LineChartEventInit>((event, emit) {
      _refreshUI();
    });
    on<LineChartEventRefresh>((event, emit) {
      _refreshUI();
    });
    on<LineChartEventDispose>((event, emit) {
      emit(LineChartStateDispose());
    });
    on<LineChartEventSetX>((event, emit) {
      xIndex = event.xIndex;
      _refreshUI();
    });
    on<LineChartEventTouch>((event, emit) {
      onTouched = event.onTouched;
      _refreshUI();
    });
  }

  @override
  static LineChartStateInit get initialState => LineChartStateInit();

  _refreshUI() {
    emit(LineChartStateNormal());
  }
}
