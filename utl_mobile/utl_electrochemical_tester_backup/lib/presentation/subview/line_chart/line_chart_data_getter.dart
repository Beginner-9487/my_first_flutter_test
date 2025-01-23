import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/dto/electrochemical_ui_dto.dart';

class LineChartDataGetter {
  LineChartDataGetter._();
  static Iterable<ElectrochemicalUiDto> data({
    required Iterable<ElectrochemicalEntity> entities,
    required Iterable<bool> shows,
  }) {
    return entities
      .indexed
      .where((e) => shows.skip(e.$2.type.index).first)
      .map((e) => e.$2.uiDto(
        dataStartIndex: 0,
        dataLength: e.$2.data.length,
        entitiesIndex: e.$1,
        entitiesLength: entities.length,
      ));
  }
}