import 'package:flutter/material.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mobile/application/use_cases/background_work_use_case.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_bloc.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_event.dart';
import 'package:utl_mobile/presentation/bloc/background_work/background_work_state.dart';

class BackgroundWorkHeader extends AppBar {
  BackgroundWorkHeader({
    super.key,
    required this.backgroundWorkBloc,
    required this.backgroundProcessor,
    this.HeaderText = "",
  });

  BackgroundWorkBloc backgroundWorkBloc;
  BackgroundProcessor backgroundProcessor;
  final String HeaderText;

  @override
  State<BackgroundWorkHeader> createState() => _BackgroundWorkHeaderState();
}

class _BackgroundWorkHeaderState extends State<BackgroundWorkHeader> {
  BackgroundWorkBloc get backgroundWorkBloc => widget.backgroundWorkBloc;
  late final BackgroundWorkUseCase _backgroundWorkUseCase;

  late final TextTheme textTheme;
  late final ColorScheme colorScheme;

  @override
  void initState() {
    _backgroundWorkUseCase = BackgroundWorkUseCase(
      widget.backgroundProcessor,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        return AppBar(
          title: Transform.translate(
            offset: const Offset(10, 0),
            child: Text(
              widget.HeaderText,
              style: textTheme.headlineLarge!.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            BlocProvider(
              create: (context) => backgroundWorkBloc,
              child: BlocBuilder<BackgroundWorkBloc, BackgroundWorkState>(
                  bloc: backgroundWorkBloc,
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () async {
                        if(backgroundWorkBloc.isRunning) {
                          backgroundWorkBloc.add(BackgroundWorkStop());
                        } else {
                          backgroundWorkBloc.add(BackgroundWorkStart());
                        }
                      },
                      icon: _backgroundWorkUseCase.isRunning ? const Icon(Icons.mode_standby) : const Icon(Icons.start),
                    );
                  },
              ),
            ),
          ],
        );
      },
    );
  }
}
