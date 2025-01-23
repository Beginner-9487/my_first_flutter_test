import 'package:flutter/material.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/presentation/view/electrochemical_command_view/electrochemical_command_tab_view.dart';
import 'package:utl_electrochemical_tester/presentation/widget/icons.dart';
import 'package:utl_electrochemical_tester/resources/controller_registry.dart';

class ElectrochemicalCommandView extends StatelessWidget {
  const ElectrochemicalCommandView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var electrochemicalCommandController = ControllerRegistry.electrochemicalCommandController;
    var tabIcons = ElectrochemicalIcons.typeIcons;
    var electrochemicalCommandTabViews = ElectrochemicalType.values.map((type) => ElectrochemicalCommandTabView(type: type));
    var tabBar = TabBar(
      isScrollable: false,
      tabs: tabIcons.map((icon) {
        return Tab(
          icon: icon,
        );
      }).toList(),
      onTap: electrochemicalCommandController.setCommandTabIndexBuffer,
    );
    var tabView = TabBarView(
      children: electrochemicalCommandTabViews.toList(),
    );
    var tabController = DefaultTabController(
      length: ElectrochemicalType.values.length,
      initialIndex: electrochemicalCommandController.getCommandTabIndexBuffer(),
      child: Scaffold(
        appBar: AppBar(
          bottom: tabBar,
        ),
        body: Expanded(
          child: tabView,
        ),
      ),
    );
    return tabController;
  }
}
