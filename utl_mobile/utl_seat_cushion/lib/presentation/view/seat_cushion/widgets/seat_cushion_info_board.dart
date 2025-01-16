import 'package:flutter/cupertino.dart';

// class SeatCushionInfoBoard extends StatelessWidget {
//   const SeatCushionInfoBoard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           return Column(
//             children: [
//               SeatCushionWidget(
//                 type: SeatCushionType.upper,
//                 width: constraints.maxWidth,
//                 height: constraints.maxHeight / 3,
//               ),
//               Divider(),
//               SeatCushionWidget(
//                 type: SeatCushionType.lower,
//                 width: constraints.maxWidth,
//                 height: constraints.maxHeight / 3,
//               ),
//               Divider(),
//               SeatCushionButtonsBoard(),
//             ],
//           );
//         }
//     );
//   }
// }