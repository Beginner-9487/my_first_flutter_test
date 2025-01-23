import 'package:flutter/material.dart';

class ElectrochemicalCommandWidgetBuilder {
  const ElectrochemicalCommandWidgetBuilder._();
  static Widget buildTile({
    required String label,
    required Widget body,
  }) {
    return ListTile(
      leading: Text(label),
      title: body,
    );
  }
}
