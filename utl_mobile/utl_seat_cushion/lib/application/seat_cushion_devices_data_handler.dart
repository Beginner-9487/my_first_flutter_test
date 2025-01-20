import 'dart:async';

import 'package:utl_seat_cushion/domain/usecase/seat_cushion_usecase.dart';

class SeatCushionDevicesDataHandler {
  final FetchReceiveSeatCushionEntityStreamUseCase fetchReceiveSeatCushionEntityStreamUseCase;
  final SaveSeatCushionEntityUseCase saveSeatCushionEntityUseCase;
  final StreamSubscription _streamSubscription;

  SeatCushionDevicesDataHandler({
    required this.fetchReceiveSeatCushionEntityStreamUseCase,
    required this.saveSeatCushionEntityUseCase,
  }) : _streamSubscription = fetchReceiveSeatCushionEntityStreamUseCase().listen((entity) {
    saveSeatCushionEntityUseCase(
      entity: entity,
    );
  });

  void dispose() {
    _streamSubscription.cancel();
  }
}
