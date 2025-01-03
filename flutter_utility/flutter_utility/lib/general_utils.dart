import 'dart:math';
import 'dart:typed_data';

extension Precision on double {
  double toPrecision(int n) {
    return (this * pow(10, n)).roundToDouble() / pow(10, n);
  }
}

extension ToUint8List on String {
  /// Converts a hex string to a Uint8List.
  /// Throws a FormatException if the string is not valid hex.
  Uint8List hexToUint8List() {
    if (length % 2 != 0) {
      throw const FormatException("Invalid hex string: length must be even.");
    }

    try {
      return Uint8List.fromList(List.generate(length ~/ 2, (int index) {
        final hexPair = substring(index * 2, index * 2 + 2);
        return int.parse(hexPair, radix: 16);
      }));
    } catch (e) {
      throw const FormatException("Invalid hex string: contains non-hexadecimal characters.");
    }
  }
}

/// Refers to https://stackoverflow.com/questions/69090275/uint8list-vs-listint-what-is-the-difference
/// Converts a `List<int>` to a [Uint8List].
///
/// Attempts to cast to a [Uint8List] first to avoid creating an unnecessary
/// copy.
extension AsUint8List on List<int> {
  Uint8List asUint8List() {
    final self = this; // Local variable to allow automatic type promotion.
    return (self is Uint8List) ? self : Uint8List.fromList(this);
  }
}
