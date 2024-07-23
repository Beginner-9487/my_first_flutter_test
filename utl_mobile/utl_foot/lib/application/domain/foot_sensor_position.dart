import 'dart:math';

import 'package:utl_foot/application/domain/foot_repository.dart';

class FootSensorPosition {
  static const int numberOfFootSensor = 31;
  static List<Point<double>> getByBodyPart(int bodyPart) {
    switch(bodyPart) {
      case BodyPart.LEFT_FOOT:
        return [
          const Point(114, 70),
          const Point(162, 72),
          const Point(77, 104),
          const Point(131, 108),
          const Point(185, 113),
          const Point(65, 150),
          const Point(125, 153),
          const Point(184, 158),
          const Point(45, 196),
          const Point(90, 199),
          const Point(139, 201),
          const Point(184, 204),
          const Point(32, 247),
          const Point(80, 249),
          const Point(133, 251),
          const Point(47, 297),
          const Point(177, 253),
          const Point(102, 299),
          const Point(158, 300),
          const Point(48, 351),
          const Point(140, 351),
          const Point(65, 392),
          const Point(111, 391),
          const Point(64, 465),
          const Point(110, 464),
          const Point(63, 514),
          const Point(109, 512),
          const Point(61, 569),
          const Point(108, 567),
          const Point(60, 624),
          const Point(107, 622),
        ];
      case BodyPart.RIGHT_FOOT:
        return [
          const Point(339, 70),
          const Point(291, 72),
          const Point(376, 104),
          const Point(322, 108),
          const Point(268, 113),
          const Point(388, 150),
          const Point(328, 153),
          const Point(269, 158),
          const Point(408, 196),
          const Point(363, 199),
          const Point(314, 201),
          const Point(269, 204),
          const Point(421, 247),
          const Point(373, 249),
          const Point(320, 251),
          const Point(276, 253),
          const Point(406, 297),
          const Point(351, 299),
          const Point(295, 300),
          const Point(405, 351),
          const Point(313, 351),
          const Point(388, 392),
          const Point(342, 391),
          const Point(389, 465),
          const Point(343, 464),
          const Point(390, 514),
          const Point(344, 512),
          const Point(392, 569),
          const Point(345, 567),
          const Point(393, 624),
          const Point(346, 622)
        ];
    }
    return [];
  }
}