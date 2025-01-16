import 'package:flutter/material.dart';
import 'package:flutter_basic_utils/presentation/dataset_color_generator.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';

class SeatCushionUnitWidget extends StatelessWidget {
  final int force;
  final double width;
  final double height;
  const SeatCushionUnitWidget({
    super.key,
    required this.force,
    required this.width,
    required this.height,
  });
  static forceColor({
    required int force,
  }) {
    int index = SeatCushionEntity.forceMax - force;
    int length = SeatCushionEntity.forceMax - SeatCushionEntity.forceMin;
    return DatasetColorGenerator.rainbow(
      alpha: 1.0,
      index: index,
      length: length,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: forceColor(force: force),
          borderRadius: BorderRadius.circular(1.0),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        width: width,
        height: height,
      ),
    );
  }
}
