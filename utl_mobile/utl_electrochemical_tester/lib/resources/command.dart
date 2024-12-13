import 'dart:typed_data';

final Uint8List startCaCommand = Uint8List.fromList([0x01]);
final Uint8List startCvCommand = Uint8List.fromList([0x02]);
final Uint8List startDpvCommand = Uint8List.fromList([0x03]);