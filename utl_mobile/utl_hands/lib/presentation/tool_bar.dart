import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';

class Toolbar {
  Toolbar(
      this.saveFileUseCase,
  );

  UpdateBloc updateBloc = UpdateBlocImpl();
  SaveFileUseCase saveFileUseCase;

  Widget build() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => updateBloc
        ),
      ],
      child: BlocBuilder(
        bloc: updateBloc,
        builder: (context, state) {
          return IconButton(
            color: (saveFileUseCase.isSavingFile) ? Colors.blue : Colors.grey,
            onPressed: () async {
              if(saveFileUseCase.isSavingFile) {
                await saveFileUseCase.stopSavingFile();
              } else {
                await saveFileUseCase.startSavingFile();
              }
              updateBloc.update();
            },
            icon: (saveFileUseCase.isSavingFile) ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
          );
        },
      ),
    );
  }
}