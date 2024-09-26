import 'dart:ui';

import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mobile/utils/data_color_generator.dart';

class MackayEntityToColor {
  MackayIRBRepository mackayIRBRepository;
  MackayEntityToColor({
    required this.mackayIRBRepository,
  });
  Color getColor(MackayIRBEntity entity) {
    (int, MackayIRBEntity)? temp = mackayIRBRepository
        .entities
        .where((element) => element.type == entity.type)
        .indexed
        .where((element) => element.$2.id == entity.id)
        .firstOrNull;
    int index = (temp != null) ? temp.$1 : 0;
    return DataColorGenerator.rainbowLayer(
      alpha: 0.75,
      currentLayerDataIndex: index + 10,
      currentLayerDataSize: mackayIRBRepository
          .entities
          .where((element) => element.type == entity.type)
          .length + 10,
      layerIndex: entity.type.id - 0x02,
      layerSize: 3,
    );
  }
}