import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:utl_mackay_irb/application/use_cases/send_all_ble_use_case.dart';

class BLECommandBar extends AppBar {
  BLECommandBar({
    super.key,
    required this.bleRepository,
    required this.sendAllBLEUseCase,
  });

  BLERepository bleRepository;
  SendAllBLEUseCase sendAllBLEUseCase;

  @override
  State<BLECommandBar> createState() => _BLECommandBarState();
}

class _BLECommandBarState extends State<BLECommandBar> {
  BLERepository get _bleRepository => widget.bleRepository;

  late final TextEditingController _bleCommandController;

  SendAllBLEUseCase get sendAllBLEUseCase => widget.sendAllBLEUseCase;

  late final TextTheme textTheme;
  late final ColorScheme colorScheme;

  @override
  void initState() {
    _bleCommandController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: _bleCommandController,
      ),
      actions: [
        IconButton(
          onPressed: () {
            sendAllBLEUseCase.sendCommand(_bleCommandController.value.text);
            _bleCommandController.clear();
          },
          icon: const Icon(Icons.send_to_mobile),
        ),
      ],
    );
  }
}
