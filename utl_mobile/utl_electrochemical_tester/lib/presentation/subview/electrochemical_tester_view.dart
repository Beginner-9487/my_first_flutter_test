import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/application/controller/bt_controller.dart';
import 'package:utl_mobile/utl_domain/utl_domain.dart';

int _electrochemical_tester_counter = 0;

enum _SELECTION {
  _CA,
  _CV,
  _DPV,
}

const String _SELECTION_KEY = "_SELECTION_KEY";

const _SELECTION _SELECTION_DEFAULT = _SELECTION._CA;

Future<bool> _save_SELECTION ({
  required SharedPreferences sharedPreferences,
  required _SELECTION selection,
}) async {
  return sharedPreferences.setInt(_SELECTION_KEY, selection.index);
}

_SELECTION _get_SELECTION({
  required SharedPreferences sharedPreferences,
}) {
  final value = sharedPreferences.getInt(_SELECTION_KEY);
  if (value == null) return _SELECTION_DEFAULT;
  return _SELECTION
      .values
      .firstWhere(
        (e) => e.index == value,
        orElse: () => _SELECTION_DEFAULT,
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

class Electrochemical_Tester_View extends StatefulWidget {
  Electrochemical_Tester_View({
    required this.bt_controller,
    required this.contextResource,
    required this.sharedPreferences,
  });

  final BT_Controller bt_controller;
  final ContextResource contextResource;
  final SharedPreferences sharedPreferences;

  @override
  State<Electrochemical_Tester_View> createState() => _Electrochemical_Tester_View_State();
}

class _Electrochemical_Tester_View_State extends State<Electrochemical_Tester_View> with WidgetsBindingObserver, TickerProviderStateMixin {
  BT_Controller get bt_controller => widget.bt_controller;
  ContextResource get contextResource => widget.contextResource;
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
        bt_controller: bt_controller,
        contextResource: contextResource,
        sharedPreferences: sharedPreferences,
      ),
      const Icon(Icons.calendar_view_day):
      _CV(
        bt_controller: bt_controller,
        contextResource: contextResource,
        sharedPreferences: sharedPreferences,
      ),
      const Icon(Icons.dew_point):
      _DPV(
        bt_controller: bt_controller,
        contextResource: contextResource,
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
    _SELECTION selection = _get_SELECTION(
      sharedPreferences: sharedPreferences,
    );
    switch(selection) {
      case _SELECTION._CA:
        tabController.index = 0;
        break;
      case _SELECTION._CV:
        tabController.index = 1;
        break;
      case _SELECTION._DPV:
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
    required this.bt_controller,
    required this.contextResource,
    required this.sharedPreferences,
  });

  final BT_Controller bt_controller;
  final ContextResource contextResource;
  final SharedPreferences sharedPreferences;

  static const String _E_dc_key = "CA_E_dc_key";
  static const String _t_interval_key = "CA_t_interval_key";
  static const String _t_run_key = "CA_t_run_key";

  final TextEditingController _E_dc_controller = TextEditingController();
  final TextEditingController _t_interval_controller = TextEditingController();
  final TextEditingController _t_run_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _save_SELECTION(
      sharedPreferences: sharedPreferences,
      selection: _SELECTION._CA,
    );

    _E_dc_controller.text = sharedPreferences.getString(_E_dc_key) ?? "";
    _t_interval_controller.text = sharedPreferences.getString(_t_interval_key) ?? "";
    _t_run_controller.text = sharedPreferences.getString(_t_run_key) ?? "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              title: contextResource.str.ca,
              onPressed: _onStartCA,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: contextResource.str.e_dc,
                    controller: _E_dc_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_dc_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.t_interval,
                    controller: _t_interval_controller,
                    onChanged: (value) => sharedPreferences.setString(_t_interval_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.t_run,
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
    for (var device in bt_controller.bt_provider.devices.where((element) => element.isConnected)) {
      bt_controller.setName(
        device,
        "${contextResource.str.ca}_${_electrochemical_tester_counter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      bt_controller.startCA(
        device,
        UTL_Data_CA_Command_Impl(
          E_dc: (double.parse(_E_dc_controller.value.text) * 1000).toInt(),
          t_interval: (double.parse(_t_interval_controller.value.text) * 1000).toInt(),
          t_run: (double.parse(_t_run_controller.value.text) * 1000).toInt(),
        ),
      );
    }
    _electrochemical_tester_counter++;
  }
}

class _CV extends StatelessWidget {
  _CV({
    required this.bt_controller,
    required this.contextResource,
    required this.sharedPreferences,
  });

  final BT_Controller bt_controller;
  final ContextResource contextResource;
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
    _save_SELECTION(
      sharedPreferences: sharedPreferences,
      selection: _SELECTION._CV,
    );

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
              title: contextResource.str.cv,
              onPressed: _onStartCV,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: contextResource.str.e_begin,
                    controller: _E_begin_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_begin_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_vertex1,
                    controller: _E_vertex1_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_vertex1_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_vertex2,
                    controller: _E_vertex2_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_vertex2_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_step,
                    controller: _E_step_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_step_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.scan_rate,
                    controller: _scan_rate_controller,
                    onChanged: (value) => sharedPreferences.setString(_scan_rate_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.number_of_scans,
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
    for (var device in bt_controller.bt_provider.devices.where((element) => element.isConnected)) {
      bt_controller.setName(
        device,
        "${contextResource.str.cv}_${_electrochemical_tester_counter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      bt_controller.startCV(
        device,
        UTL_Data_CV_Command_Impl(
          E_begin: (double.parse(_E_begin_controller.value.text) * 1000).toInt(),
          E_vertex1: (double.parse(_E_vertex1_controller.value.text) * 1000).toInt(),
          E_vertex2: (double.parse(_E_vertex2_controller.value.text) * 1000).toInt(),
          E_step: (double.parse(_E_step_controller.value.text) * 1000).toInt(),
          scan_rate: (double.parse(_scan_rate_controller.value.text) * 1000).toInt(),
          number_of_scans: int.parse(_number_of_scans_controller.value.text),
        ),
      );
    }
    _electrochemical_tester_counter++;
  }
}

class _DPV extends StatelessWidget {
  _DPV({
    required this.bt_controller,
    required this.contextResource,
    required this.sharedPreferences,
  });

  final BT_Controller bt_controller;
  final ContextResource contextResource;
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
    _save_SELECTION(
      sharedPreferences: sharedPreferences,
      selection: _SELECTION._DPV,
    );

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
              title: contextResource.str.dpv,
              onPressed: _onStartDPV,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _buildInputField(
                    label: contextResource.str.e_begin,
                    controller: _E_begin_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_begin_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_end,
                    controller: _E_end_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_end_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_step,
                    controller: _E_step_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_step_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.e_pulse,
                    controller: _E_pulse_controller,
                    onChanged: (value) => sharedPreferences.setString(_E_pulse_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.t_pulse,
                    controller: _t_pulse_controller,
                    onChanged: (value) => sharedPreferences.setString(_t_pulse_key, value),
                  ),
                  _buildInputField(
                    label: contextResource.str.scan_rate,
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
    for (var device in bt_controller.bt_provider.devices.where((element) => element.isConnected)) {
      bt_controller.setName(
        device,
        "${contextResource.str.dpv}_${_electrochemical_tester_counter.toString().padLeft(2, '0')}_${device.name}_${device.address}",
      );
      bt_controller.startDPV(
        device,
        UTL_Data_DPV_Command_Impl(
          E_begin: (double.parse(_E_begin_controller.value.text) * 1000).toInt(),
          E_end: (double.parse(_E_end_controller.value.text) * 1000).toInt(),
          E_step: (double.parse(_E_step_controller.value.text) * 1000).toInt(),
          E_pulse: (double.parse(_E_pulse_controller.value.text) * 1000).toInt(),
          t_pulse: (double.parse(_t_pulse_controller.value.text) * 1000).toInt(),
          scan_rate: (double.parse(_scan_rate_controller.value.text) * 1000).toInt(),
        ),
      );
    }
    _electrochemical_tester_counter++;
  }
}
