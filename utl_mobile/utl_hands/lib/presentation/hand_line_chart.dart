import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/src/chart/user_interaction/trackball.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_mobile/utl_line_chart_impl.dart';

class HandLineChart extends UTL_Line_Chart_Impl_Base {
  HandLineChart({
    required this.handRepository,
  });
  final HandRepository handRepository;

  @override
  TrackballBehavior? get trackballBehavior => TrackballBehavior(
    enable: true,
    // shouldAlwaysShow: true,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    activationMode: ActivationMode.singleTap,
    tooltipAlignment: ChartAlignment.near,
  );

  @override
  get primaryYAxis => NumericAxis(minimum: 25000);
}