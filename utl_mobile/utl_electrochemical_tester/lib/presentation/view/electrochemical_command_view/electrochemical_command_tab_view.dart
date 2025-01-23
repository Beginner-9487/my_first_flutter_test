import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/item/electrochemical_command_ad5940_view.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/item/electrochemical_command_header_view.dart';

class ElectrochemicalCommandTabView extends StatelessWidget {
  final ElectrochemicalType type;
  const ElectrochemicalCommandTabView({
    super.key,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElectrochemicalCommandHeaderView(type: type),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              ElectrochemicalCommandAd5940View(),
              Divider(),
              ElectrochemicalCommandTabView(type: type),
            ],
          ),
        ),
      ],
    );
  }
}
