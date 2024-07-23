import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_foot/application/use_cases/save_file_use_case.dart';
import 'package:utl_foot/application/use_cases/send_all_ble_use_case.dart';
import 'package:utl_foot/resources/app_theme.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';

class BLEAndFileControllerBar extends AppBar {
  BLEAndFileControllerBar({
    super.key,
    required this.isSavingFileBloc,
    required this.bleRepository,
    required this.saveFileUseCase,
    required this.sendAllBLEUseCase,
  });

  UpdateBloc isSavingFileBloc;
  BLERepository bleRepository;
  SaveFileUseCase saveFileUseCase;
  SendAllBLEUseCase sendAllBLEUseCase;

  @override
  State<BLEAndFileControllerBar> createState() => _BLEAndFileControllerBarState();
}

class _BLEAndFileControllerBarState extends State<BLEAndFileControllerBar> {
  UpdateBloc get _isSavingFileBloc => widget.isSavingFileBloc;
  BLERepository get _bleRepository => widget.bleRepository;

  SaveFileUseCase get saveFileUseCase => widget.saveFileUseCase;
  SendAllBLEUseCase get sendAllBLEUseCase => widget.sendAllBLEUseCase;

  late final TextEditingController _bleCommandController;

  late final TextTheme textTheme;
  late final ColorScheme colorScheme;

  @override
  void initState() {
    _bleCommandController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => _isSavingFileBloc..add(const UpdateEvent()),
      child: AppBar(
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
          BlocBuilder<UpdateBloc, UpdateState>(
              bloc: _isSavingFileBloc,
              builder: (context, state) {
                return IconButton(
                  color: (saveFileUseCase.isSavingFile)
                      ? AppTheme.bleConnectedColor
                      : AppTheme.bleDisconnectedColor,
                  onPressed: () {
                    if(saveFileUseCase.isSavingFile) {
                      saveFileUseCase.stopSavingFile();
                    } else {
                      saveFileUseCase.startSavingFile();
                    }
                  },
                  icon: (saveFileUseCase.isSavingFile)
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                );
              },
          ),
        ],
      ),
    );
  }
}
