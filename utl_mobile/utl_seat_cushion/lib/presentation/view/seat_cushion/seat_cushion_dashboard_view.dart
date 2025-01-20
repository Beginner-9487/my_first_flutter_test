import 'package:flutter/material.dart';
import 'package:utl_seat_cushion/application/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_buttons_board.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_force_color_bar.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_widget.dart';
import 'package:utl_seat_cushion/resources/application_resources.dart';

class SeatCushionDashboardView extends StatefulWidget {
  const SeatCushionDashboardView({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _SeatCushionDashboardViewState();
}

class _SeatCushionDashboardViewState extends State<SeatCushionDashboardView> {
  final SeatCushionDataViewController seatCushionDataViewController = ApplicationResources.seatCushionDataViewController;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            SeatCushionWidget(
              type: SeatCushionType.upper,
              width: constraints.maxWidth,
              height: constraints.maxHeight / 3,
            ),
            Divider(),
            SeatCushionWidget(
              type: SeatCushionType.lower,
              width: constraints.maxWidth,
              height: constraints.maxHeight / 3,
            ),
            Divider(),
            SeatCushionButtonsBoard(),
            SeatCushionForceColorBar(
              colorWidth: constraints.maxWidth,
              colorHeight: 10,
            ),
          ],
        );
      }
    );
  }
}
