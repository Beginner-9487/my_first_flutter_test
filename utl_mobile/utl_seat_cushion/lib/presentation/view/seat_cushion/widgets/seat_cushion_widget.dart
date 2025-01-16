import 'package:flutter/material.dart';
import 'package:utl_seat_cushion/application/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_matrix_widget.dart';
import 'package:utl_seat_cushion/resources/application_resources.dart';

class SeatCushionWidget extends StatelessWidget {
  final SeatCushionType type;
  final SeatCushionDataViewController seatCushionDataViewController = ApplicationResources.seatCushionDataViewController;
  final double width;
  final double height;
  Iterable<int> sortForces({
    required SeatCushionType type,
    required List<int> forces,
  }) {
    switch(type) {
      case SeatCushionType.upper:
        return forces.reversed;
      case SeatCushionType.lower:
        return forces;
    }
  }
  SeatCushionWidget({
    super.key,
    required this.type,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: seatCushionDataViewController
          .bufferStream
          .where((data) => data.type == type)
          .map((data) => data.forces),
      builder: (context, snapshot) {
        var forces = snapshot.data;
        if(forces != null) forces = sortForces(type: type, forces: forces).toList();
        return SeatCushionMatrixWidget(
          type: type,
          forces: forces,
          width: width,
          height: height,
        );
      },
    );
  }
}
