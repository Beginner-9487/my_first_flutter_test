import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_tab_view.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/init/controller_registry.dart';

class ElectrochemicalCommandView extends StatelessWidget {
  const ElectrochemicalCommandView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    final tabIconData = ElectrochemicalIcons.typeIconData;
    final electrochemicalCommandTabViews = ElectrochemicalType.values.map((type) => ElectrochemicalCommandTabView(type: type));
    final tabBar = TabBar(
      isScrollable: false,
      tabs: tabIconData.map((iconData) {
        return Tab(
          icon: Icon(iconData),
        );
      }).toList(),
      onTap: electrochemicalCommandController.setCommandTabIndexBuffer,
    );
    final tabView = TabBarView(
      children: electrochemicalCommandTabViews.toList(),
    );
    final tabController = DefaultTabController(
      length: ElectrochemicalType.values.length,
      initialIndex: electrochemicalCommandController.getCommandTabIndexBuffer(),
      child: Scaffold(
        appBar: tabBar,
        body: tabView,
      ),
    );
    return tabController;
  }
}
