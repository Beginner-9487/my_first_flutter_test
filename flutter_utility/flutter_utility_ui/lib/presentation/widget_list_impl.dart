import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_utility_ui/presentation/widget_list.dart';

class Widget_List_Impl extends Widget_List {
  Widget_List_Impl({
    super.key,
    this.widgets = const [],
  });

  UpdateBloc bloc = UpdateBlocImpl();

  List<Widget> widgets;

  @override
  void update(List<Widget> widgets) {
    this.widgets = widgets;
    bloc.update();
  }

  @override
  State<Widget_List_Impl> createState() => _Widget_List_Impl_State();
}

class _Widget_List_Impl_State<View extends Widget_List_Impl> extends State<View> {
  UpdateBloc get bloc => widget.bloc;
  List<Widget> get widgets => widget.widgets;

  late final Widget view;

  @override
  void initState() {
    super.initState();
    view = BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder(
          bloc: bloc,
          builder: (context, blueState) {
            return ListView(
              children: widgets,
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return view;
  }
}