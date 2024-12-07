import 'dart:typed_data';

final Uint8List START_CA_COMMAND = Uint8List.fromList([0x30]);
final Uint8List START_CV_COMMAND = Uint8List.fromList([0x32]);
final Uint8List START_DPV_COMMAND = Uint8List.fromList([0x32]);
final Uint8List START_HUMAN_TRIALS_COMMAND = Uint8List.fromList([0x65]);