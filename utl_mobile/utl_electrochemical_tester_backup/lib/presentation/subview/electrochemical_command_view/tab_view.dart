import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/domain/value/ad5940_parameters.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ElectrochemicalCommandTabView extends StatefulWidget {
  const ElectrochemicalCommandTabView({
    super.key,
  });
}

abstract class ElectrochemicalCommandTabViewState<View extends ElectrochemicalCommandTabView> extends State<View> with WidgetsBindingObserver {
  late final ElectrochemicalCommandController electrochemicalCommandController;
  late final SharedPreferences sharedPreferences;
  String get title;
  static const String dataNameKey = "dataNameKey";
  final TextEditingController dataNameController = TextEditingController();
  Widget get dataNameInputField => Expanded(
    child: buildTextInputField(
      label: "$title: ${AppLocalizations.of(context)!.name}",
      controller: dataNameController,
      onChanged: (value) => sharedPreferences.setString(dataNameKey, value),
    ),
  );
  String get dataName => dataNameController.text;
  static const String ad5940HsRTiaKey = "AD5940_HsRTia_key";
  int ad5940HsRTiaValue = 0;
  Widget get ad5940HsRTiaRow => buildDropdownMenu(
    label: AppLocalizations.of(context)!.ad5940HsRTia,
    initialSelection: ad5940HsRTiaValue,
    onSelected: (int? value) {
      ad5940HsRTiaValue = value ?? ad5940HsRTiaValue;
      sharedPreferences.setInt(ad5940HsRTiaKey, ad5940HsRTiaValue);
    },
    dropdownMenuEntries: AD5940ParametersHsTiaRTia.values.map((hsTiaRTia) => DropdownMenuEntry(
      value: hsTiaRTia.index,
      label: hsTiaRTia.name,
    )).toList(),
  );
  AD5940Parameters get ad5940Parameters => AD5940Parameters(
    hsTiaRTia: AD5940ParametersHsTiaRTia.values[ad5940HsRTiaValue],
  );
  Widget buildHeader({
    required void Function()? onPressed,
  }) {
    return Row(
      children: [
        dataNameInputField,
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
  Widget buildTextInputField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return ListTile(
      leading: Text(label),
      title: TextField(
        controller: controller,
        onChanged: onChanged,
      ),
    );
  }
  Widget buildNumberInputField({
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
  Widget buildDropdownMenu({
    required String label,
    required int initialSelection,
    required void Function(int? value) onSelected,
    required List<DropdownMenuEntry<int>> dropdownMenuEntries,
  }) {
    return ListTile(
      leading: Text(label),
      title: DropdownMenu<int>(
        initialSelection: initialSelection,
        onSelected: onSelected,
        dropdownMenuEntries: dropdownMenuEntries,
      ),
    );
  }
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    electrochemicalCommandController = context.read<ElectrochemicalCommandController>();
    sharedPreferences = context.read<SharedPreferences>();
    dataNameController.text = sharedPreferences.getString(dataNameKey)?.toString() ?? "";
    ad5940HsRTiaValue = AD5940ParametersHsTiaRTia.values[sharedPreferences.getInt(ad5940HsRTiaKey) ?? 0].index;
  }
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    setState(() {});
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}