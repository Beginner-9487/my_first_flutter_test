import 'package:flutter/material.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_unit_widget.dart';

class SeatCushionMatrixWidget extends StatelessWidget {
  static const row = 8;
  static const column = 31;
  final SeatCushionType type;
  final Iterable<int>? forces;
  final double width;
  final double height;
  const SeatCushionMatrixWidget({
    super.key,
    required this.type,
    required this.forces,
    required this.width,
    required this.height,
  });
  Iterable<int> get nullForces => Iterable.generate(SeatCushionEntity.forceLength, (index) => 0);
  @override
  Widget build(BuildContext context) {
    Iterable<Iterable<int>> forceMatrix = Iterable.generate(row, (indexRow) {
      return Iterable.generate(column, (indexColumn) {
        return (forces ?? nullForces).skip(indexRow * column + indexColumn).first;
      });
    });
    return Column(
      children: forceMatrix.map((rowForces) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowForces.map((force) {
            return SeatCushionUnitWidget(
              force: force,
              width: width / column,
              height: height / row,
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
