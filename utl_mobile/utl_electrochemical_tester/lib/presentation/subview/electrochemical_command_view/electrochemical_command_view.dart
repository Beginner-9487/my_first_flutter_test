import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/ca.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/cv.dart';
import 'package:utl_electrochemical_tester/presentation/subview/electrochemical_command_view/dpv.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';

class ElectrochemicalCommandView extends StatefulWidget {
  const ElectrochemicalCommandView({
    super.key,
  });
  @override
  State<ElectrochemicalCommandView> createState() => _ElectrochemicalCommandViewState();
}

class _ElectrochemicalCommandViewState extends State<ElectrochemicalCommandView> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static const String _electrochemicalCommandViewSelectionKey = "_ElectrochemicalCommandViewSelectionKey";
  late final SharedPreferences sharedPreferences;
  late final TabController tabController;
  late final Map<Icon, Widget> tabViewMap;
  TabBarView get buildTabBarView => TabBarView(
    controller: tabController,
    children: tabViewMap.values.toList(),
  );
  TabBar get buildTabBar => TabBar(
    isScrollable: false,
    controller: tabController,
    tabs: tabViewMap.keys.map((title) {
      return Tab(
        icon: title,
      );
    }).toList(),
    onTap: (index) {
      sharedPreferences.setInt(_electrochemicalCommandViewSelectionKey, index);
    },
  );
  Widget get buildView => Scaffold(
    body: SafeArea(
      child: Column(children: <Widget>[
        buildTabBar,
        Expanded(
          child: buildTabBarView,
        ),
      ]),
    ),
  );
  @override
  void initState() {
    super.initState();
    sharedPreferences = context.read<SharedPreferences>();
    tabViewMap = {
      ElectrochemicalTypeIcons.ca:
      CaElectrochemicalCommandTabView(),
      ElectrochemicalTypeIcons.cv:
      CvElectrochemicalCommandTabView(),
      ElectrochemicalTypeIcons.dpv:
      DpvElectrochemicalCommandTabView(),
    };
    tabController = TabController(
      length: tabViewMap.length,
      vsync: this,
    );
    tabController.index = sharedPreferences.getInt(_electrochemicalCommandViewSelectionKey) ?? 0;
    return;
  }
  @override
  Widget build(BuildContext context) {
    return buildView;
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
