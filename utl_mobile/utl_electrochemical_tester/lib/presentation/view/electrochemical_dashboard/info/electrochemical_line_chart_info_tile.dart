import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _Item {
  String label;
  String data;
  _Item({
    required this.label,
    required this.data,
  });
}

class ElectrochemicalLineChartInfoTile extends StatelessWidget {
  final ElectrochemicalLineChartInfoDto infoDto;
  final ElectrochemicalLineChartMode mode;
  const ElectrochemicalLineChartInfoTile({
    super.key,
    required this.infoDto,
    required this.mode,
  });
  Widget buildText({
    required List<_Item> items,
    required Color color,
  }) {
    String text = (items.isNotEmpty) ? "${items.first.label}: ${items.first.data}" : "";
    for(int i=1; i<items.length; i++) {
      text += ", ${items.skip(i).first.label}: ${items.skip(i).first.data}";
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  Widget buildText2({
    required String label,
    required Iterable<String> data,
    required Color color,
  }) {
    String text = (data.isNotEmpty) ? data.first : "";
    for(int i=1; i<data.length; i++) {
      text += ", ${data.skip(i).first}";
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            "$label: $text",
            softWrap: true,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    _Item xItem;
    switch (mode) {
      case ElectrochemicalLineChartMode.ampereIndex:
        xItem = _Item(
          label: appLocalizations.index,
          data: infoDto.data.firstOrNull?.index.toString() ?? "",
        );
        break;
      case ElectrochemicalLineChartMode.ampereTime:
        xItem = _Item(
          label: appLocalizations.time,
          data: infoDto.data.firstOrNull?.time.toString() ?? "",
        );
        break;
      case ElectrochemicalLineChartMode.ampereVolt:
        xItem = _Item(
          label: appLocalizations.voltage,
          data: infoDto.data.firstOrNull?.voltage.toString() ?? "",
        );
        break;
    }
    Widget yItem = buildText2(
      label: appLocalizations.current,
      data: infoDto
          .data
          .map((e) => e.current.toString()),
      color: infoDto
          .color,
    );
    return Column(
      children: [
        buildText(
          items: [
            _Item(
              label: appLocalizations.name,
              data: infoDto.dataName,
            ),
            _Item(
              label: appLocalizations.type,
              data: infoDto.dataName,
            ),
            _Item(
              label: appLocalizations.temperature,
              data: infoDto.temperature.toString(),
            ),
          ],
          color: infoDto.color,
        ),
        buildText(
          items: [
            _Item(
              label: appLocalizations.time,
              data: infoDto.createdTime.toString(),
            ),
          ],
          color: infoDto.color,
        ),
        buildText(
          items: [
            xItem,
          ],
          color: infoDto.color,
        ),
        yItem,
        Divider(),
      ],
    );
  }
}
