import 'package:equatable/equatable.dart';

enum SeatCushionType {
  upper,
  lower,
}

class SeatCushionEntity extends Equatable {
  static const int forceLength = 248;
  static const int forceMax = 3500;
  static const int forceMin = 0;
  final int id;
  final String deviceId;
  final List<int> forces;
  final SeatCushionType type;
  const SeatCushionEntity({
    required this.id,
    required this.deviceId,
    required this.forces,
    required this.type,
  });
  @override
  List<Object?> get props => [id];
}
