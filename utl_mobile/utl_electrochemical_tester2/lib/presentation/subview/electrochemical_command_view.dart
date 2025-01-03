import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int _electrochemicalCounter = 0;

enum _Selection {
  ca,
  cv,
  dpv,
}

const String _selectionKey = "_selectionKey";

const _Selection _defaultSelection = _Selection.ca;

Future<bool> _saveSelection ({
  required SharedPreferences sharedPreferences,
  required _Selection selection,
}) async {
  return sharedPreferences.setInt(_selectionKey, selection.index);
}

_Selection _getSelection({
  required SharedPreferences sharedPreferences,
}) {
  final value = sharedPreferences.getInt(_selectionKey);
  if (value == null) return _defaultSelection;
  return _Selection
      .values
      .firstWhere(
        (e) => e.index == value,
        orElse: () => _defaultSelection,
      );
}

Widget _buildInputField({
  required String label,
  required TextEditingController controller,
  required Function(String) onChanged,
}) {
  return ListTile(
    leading: Text(label),
    title: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    ),
  );
}

Widget _buildHeader({
  required String title,
  required void Function()? onPressed,
}) {
  return Row(
    children: [
      Text(title),
      const Spacer(),
      IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.send),
      ),
    ],
  );
}

class ElectrochemicalCommandView extends StatefulWidget {
  const ElectrochemicalCommandView({
    super.key,
    required this.controller,
    required this.sharedPreferences,
  });

  final ElectrochemicalCommandController controller;
  final SharedPreferences sharedPreferences;

  @override
  State<ElectrochemicalCommandView> createState() => _ElectrochemicalCommandViewState();
}

class _ElectrochemicalCommandViewState extends State<ElectrochemicalCommandView> with WidgetsBindingObserver, TickerProviderStateMixin {
  ElectrochemicalCommandController get controller => widget.controller;
  SharedPreferences get sharedPreferences => widget.sharedPreferences;

  late final Map<Icon, Widget> tabViewMap;
  late final TabController tabController;
  late final TabBarView tabBarView;
  late final TabBar tabBar;

  @override
  void initState() {
    super.initState();

    tabViewMap = {
      const Icon(Icons.cabin):
      _CA(
        controller: controller,
        sharedPreferences: sharedPreferences,
      ),
      const Icon(Icons.calendar_view_day):
      _CV(
        controller: controller,
        sharedPreferences: sharedPreferences,
      ),
      const Icon(Icons.dew_point):
      _DPV(
        controller: controller,
        sharedPreferences: sharedPreferences,
      ),
    };

    tabController = TabController(
      length: tabViewMap.length,
      vsync: this,
    );

    tabBarView = TabBarView(
      controller: tabController,
      children: tabViewMap.values.toList(),
    );

    tabBar = TabBar(
      isScrollable: false,
      controller: tabController,
      tabs: tabViewMap.keys.map((title) {
        return Tab(
          icon: title,
        );
      }).toList(),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    _Selection selection = _getSelection(
      sharedPreferences: sharedPreferences,
    );
    switch(selection) {
      case _Selection.ca:
        tabController.index = 0;
        break;
      case _Selection.cv:
        tabController.index = 1;
        break;
      case _Selection.dpv:
        tabController.index = 2;
        break;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          tabBar,
          Expanded(
            child: tabBarView,
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in background
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
    }
  }
}

class _CA extends StatelessWidget {
  _CA({
    required this.controller,
    required this.sharedPreferences,
  });

  late final AppLocalizations str;

  final ElectrochemicalCommandController controller;
  final SharedPreferences sharedPreferences;

  static const String _E_dc_key = "CA_E_dc_key";
  static const String _t_interval_key = "CA_t_interval_key";
  static const String _t_run_key = "CA_t_run_key";

  final TextEditingController _E_dc_controller = TextEditingController();
  final TextEditingController _t_interval_controller = TextEditingController();
  final TextEditingController _t_run_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _saveSelection(
      sharedPreferences: sharedPreferences,
      selection: _Selection.ca,
    );

    str = context.appLocalizations!;

    _E_dc_controller.text = sharedPreferences.getString(_E_dc_key) ?? "";
    _t_interval_controller.text = sharedPreferences.getString(_t_interval_key) ?? "";
    _t_run_controller.text = sharedPreferences.getString(_t_run_key) ?? "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              title: str.ca,
              onPressed: _onStartCA,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: str.e_dc,
                    controller: _E_dc_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_dc_key, value),
                  ),
                  _buildInputField(
                    label: str.t_interval,
                    controller: _t_interval_controller,
                    onChanged: (value) => sharedPreferences.setString(_t_interval_key, value),
                  ),
                  _buildInputField(
                    label: str.t_run,
                    controller: _t_run_controller,
                    onChanged: (value) => sharedPreferences.setString(_t_run_key, value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartCA() {
    for (var device in controller.devices) {
      controller.setName(
        device,
        "${str.ca}_${_electrochemicalCounter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      controller.startCa(
        CaSentPacket(
          parameters: CaElectrochemicalParameters(
            eDc: (double.parse(_E_dc_controller.value.text) * 1000).toInt(),
            tInterval: (double.parse(_t_interval_controller.value.text) * 1000).toInt(),
            tRun: (double.parse(_t_run_controller.value.text) * 1000).toInt(),
          ),
        ),
      );
    }
    _electrochemicalCounter++;
  }
}

class _CV extends StatelessWidget {
  _CV({
    required this.controller,
    required this.sharedPreferences,
  });

  late final AppLocalizations str;

  final ElectrochemicalCommandController controller;
  final SharedPreferences sharedPreferences;

  static const String _E_begin_key = "CV_E_begin_key";
  static const String _E_vertex1_key = "CV_E_vertex1_key";
  static const String _E_vertex2_key = "CV_E_vertex2_key";
  static const String _E_step_key = "CV_E_step_key";
  static const String _scan_rate_key = "CV_scan_rate_key";
  static const String _number_of_scans_key = "CV_number_of_scans_key";

  final TextEditingController _E_begin_controller = TextEditingController();
  final TextEditingController _E_vertex1_controller = TextEditingController();
  final TextEditingController _E_vertex2_controller = TextEditingController();
  final TextEditingController _E_step_controller = TextEditingController();
  final TextEditingController _scan_rate_controller = TextEditingController();
  final TextEditingController _number_of_scans_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _saveSelection(
      sharedPreferences: sharedPreferences,
      selection: _Selection.cv,
    );

    str = context.appLocalizations!;

    _E_begin_controller.text = sharedPreferences.getString(_E_begin_key) ?? "";
    _E_vertex1_controller.text = sharedPreferences.getString(_E_vertex1_key) ?? "";
    _E_vertex2_controller.text = sharedPreferences.getString(_E_vertex2_key) ?? "";
    _E_step_controller.text = sharedPreferences.getString(_E_step_key) ?? "";
    _scan_rate_controller.text = sharedPreferences.getString(_scan_rate_key) ?? "";
    _number_of_scans_controller.text = sharedPreferences.getString(_number_of_scans_key) ?? "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              title: str.cv,
              onPressed: _onStartCV,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: str.e_begin,
                    controller: _E_begin_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_begin_key, value),
                  ),
                  _buildInputField(
                    label: str.e_vertex1,
                    controller: _E_vertex1_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_vertex1_key, value),
                  ),
                  _buildInputField(
                    label: str.e_vertex2,
                    controller: _E_vertex2_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_vertex2_key, value),
                  ),
                  _buildInputField(
                    label: str.e_step,
                    controller: _E_step_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_step_key, value),
                  ),
                  _buildInputField(
                    label: str.scan_rate,
                    controller: _scan_rate_controller,
                    onChanged: (value) => sharedPreferences.setString(_scan_rate_key, value),
                  ),
                  _buildInputField(
                    label: str.number_of_scans,
                    controller: _number_of_scans_controller,
                    onChanged: (value) => sharedPreferences.setString(_number_of_scans_key, value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartCV() {
    for (var device in controller.devices) {
      controller.setName(
        device,
        "${str.cv}_${_electrochemicalCounter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      controller.startCv(
        CvSentPacket(
          parameters: CvElectrochemicalParameters(
            eBegin: (double.parse(_E_begin_controller.value.text) * 1000).toInt(),
            eVertex1: (double.parse(_E_vertex1_controller.value.text) * 1000).toInt(),
            eVertex2: (double.parse(_E_vertex2_controller.value.text) * 1000).toInt(),
            eStep: (double.parse(_E_step_controller.value.text) * 1000).toInt(),
            scanRate: (double.parse(_scan_rate_controller.value.text) * 1000).toInt(),
            numberOfScans: int.parse(_number_of_scans_controller.value.text),
          ),
        ),
      );
    }
    _electrochemicalCounter++;
  }
}

class _DPV extends StatelessWidget {
  _DPV({
    required this.controller,
    required this.sharedPreferences,
  });

  late final AppLocalizations str;

  final ElectrochemicalCommandController controller;
  final SharedPreferences sharedPreferences;

  static const String _E_begin_key = "DPV_E_begin_key";
  static const String _E_end_key = "DPV_E_end_key";
  static const String _E_step_key = "DPV_E_step_key";
  static const String _E_pulse_key = "DPV_E_pulse_key";
  static const String _t_pulse_key = "DPV_t_pulse_key";
  static const String _scan_rate_key = "DPV_scan_rate_key";

  final TextEditingController _E_begin_controller = TextEditingController();
  final TextEditingController _E_end_controller = TextEditingController();
  final TextEditingController _E_step_controller = TextEditingController();
  final TextEditingController _E_pulse_controller = TextEditingController();
  final TextEditingController _t_pulse_controller = TextEditingController();
  final TextEditingController _scan_rate_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _saveSelection(
      sharedPreferences: sharedPreferences,
      selection: _Selection.dpv,
    );

    str = context.appLocalizations!;

    _E_begin_controller.text = sharedPreferences.getString(_E_begin_key) ?? "";
    _E_end_controller.text = sharedPreferences.getString(_E_end_key) ?? "";
    _E_step_controller.text = sharedPreferences.getString(_E_step_key) ?? "";
    _E_pulse_controller.text = sharedPreferences.getString(_E_pulse_key) ?? "";
    _t_pulse_controller.text = sharedPreferences.getString(_t_pulse_key) ?? "";
    _scan_rate_controller.text = sharedPreferences.getString(_scan_rate_key) ?? "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              title: str.dpv,
              onPressed: _onStartDPV,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: str.e_begin,
                    controller: _E_begin_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_begin_key, value),
                  ),
                  _buildInputField(
                    label: str.e_end,
                    controller: _E_end_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_end_key, value),
                  ),
                  _buildInputField(
                    label: str.e_step,
                    controller: _E_step_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_step_key, value),
                  ),
                  _buildInputField(
                    label: str.e_pulse,
                    controller: _E_pulse_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_pulse_key, value),
                  ),
                  _buildInputField(
                    label: str.t_pulse,
                    controller: _t_pulse_controller,
                    onChanged: (value) => sharedPreferences.setString(_t_pulse_key, value),
                  ),
                  _buildInputField(
                    label: str.scan_rate,
                    controller: _scan_rate_controller,
                    onChanged: (value) => sharedPreferences.setString(_scan_rate_key, value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartDPV() {
    for (var device in controller.devices) {
      controller.setName(
        device,
        "${str.dpv}_${_electrochemicalCounter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      controller.startDpv(
        DpvSentPacket(
          parameters: DpvElectrochemicalParameters(
            eBegin: (double.parse(_E_begin_controller.value.text) * 1000).toInt(),
            eEnd: (double.parse(_E_end_controller.value.text) * 1000).toInt(),
            eStep: (double.parse(_E_step_controller.value.text) * 1000).toInt(),
            ePulse: (double.parse(_E_pulse_controller.value.text) * 1000).toInt(),
            tPulse: (double.parse(_t_pulse_controller.value.text) * 1000).toInt(),
            scanRate: (double.parse(_scan_rate_controller.value.text) * 1000).toInt(),
          ),
        ),
      );
    }
    _electrochemicalCounter++;
  }
}
