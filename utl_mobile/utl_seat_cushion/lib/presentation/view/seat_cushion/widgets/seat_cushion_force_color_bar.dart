import 'package:flutter/cupertino.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/presentation/view/seat_cushion/widgets/seat_cushion_unit_widget.dart';

class SeatCushionForceColorBar extends StatelessWidget {
  final double colorWidth;
  final double colorHeight;
  const SeatCushionForceColorBar({
    super.key,
    required this.colorWidth,
    required this.colorHeight,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: colorWidth,
            height: colorHeight,
            // constraints: BoxConstraints(
            //   maxHeight: height,
            //   maxWidth: width,
            // ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: List.generate(
                  64,
                  (index) => SeatCushionUnitWidget.forceColor(force: ((SeatCushionEntity.forceMax + SeatCushionEntity.forceMin) * index / 64).toInt()),
                ),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Row(
            children: [
              Text((SeatCushionEntity.forceMin / 1000.0).toString()),
              Spacer(),
              Text((SeatCushionEntity.forceMax / 1000.0).toString()),
            ],
          )
        ],
      ),
    );
  }
}
