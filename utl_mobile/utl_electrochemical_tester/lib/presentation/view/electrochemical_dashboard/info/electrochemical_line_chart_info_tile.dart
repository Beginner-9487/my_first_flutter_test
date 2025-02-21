import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _Item {
  final String label;
  final String data;
  const _Item({
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
  Widget _buildText({
    required List<_Item> items,
    required Color color,
  }) {
    final text = items.map((item) => "${item.label}: ${item.data}").join(", ");
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
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final yItem = _Item(
      label: appLocalizations.current,
      data: infoDto
        .data
        .map((e) => e.current.toString())
        .join(", "),
    );
    return Column(
      children: [
        _buildText(
          items: [
            _Item(
              label: appLocalizations.name,
              data: infoDto.dataName,
            ),
            _Item(
              label: appLocalizations.type,
              data: infoDto.type.name,
            ),
          ],
          color: infoDto.color,
        ),
        _buildText(
          items: [
            _Item(
              label: appLocalizations.temperature,
              data: infoDto.temperature.toString(),
            ),
          ],
          color: infoDto.color,
        ),
        _buildText(
          items: [
            _Item(
              label: appLocalizations.time,
              data: infoDto.createdTime.toString(),
            ),
          ],
          color: infoDto.color,
        ),
        _buildText(
          items: [
            yItem,
          ],
          color: infoDto.color,
        ),
        Divider(),
      ],
    );
  }
}
