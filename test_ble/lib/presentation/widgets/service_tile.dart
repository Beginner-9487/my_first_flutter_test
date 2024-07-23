import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:test_ble/presentation/widgets/characteristic_tile.dart';

class ServiceTile extends StatelessWidget {
  final BLEService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({super.key, required this.service, required this.characteristicTiles});

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return characteristicTiles.isNotEmpty
        ? ExpansionTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Service', style: TextStyle(color: Colors.blue)),
          buildUuid(context),
        ],
      ),
      children: characteristicTiles,
    )
        : ListTile(
      title: const Text('Service'),
      subtitle: buildUuid(context),
    );
  }
}