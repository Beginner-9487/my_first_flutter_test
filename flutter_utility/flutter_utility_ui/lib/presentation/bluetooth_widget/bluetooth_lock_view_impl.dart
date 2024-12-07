import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_lock_view.dart';

class BluetoothLockViewImpl extends BluetoothLockView {
  const BluetoothLockViewImpl({
    super.key,
    required this.provider,
    required this.mainScreen,
    this.lockScreen,
  });
  final BT_Provider provider;
  final Widget mainScreen;
  final Widget? lockScreen;
  @override
  State<BluetoothLockViewImpl> createState() => _BluetoothLockViewImplState();
}

class _BluetoothLockViewImplState extends State<BluetoothLockViewImpl> {
  BT_Provider get provider => widget.provider;
  bool get isBluetoothOn => provider.isBluetoothOn;
  Widget get mainScreen => widget.mainScreen;
  Widget get lockScreen => (widget.lockScreen != null)
      ? widget.lockScreen!
      : BluetoothOffViewDefault(provider: provider,);
  UpdateBloc onSwitchBloc = UpdateBlocImpl();
  late StreamSubscription onSwitch;

  @override
  void initState() {
    super.initState();
    onSwitch = provider.onAdapterStateChange((state) {
      onSwitchBloc.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocProvider(
          create: (context) => onSwitchBloc,
          child: BlocBuilder(
              bloc: onSwitchBloc,
              builder: (context, state) {
                return (isBluetoothOn) ?
                mainScreen :
                lockScreen;
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    onSwitch.cancel();
  }
}

class BluetoothOffViewDefault extends StatelessWidget {
  const BluetoothOffViewDefault({
    super.key,
    required this.provider,
  });
  final BT_Provider provider;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.white54,
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      'Bluetooth Adapter is not available.',
      style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: const Text('TURN ON'),
        onPressed: () async {
          return provider.turnOn();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildBluetoothOffIcon(context),
              buildTitle(context),
              if (Platform.isAndroid) buildTurnOnButton(context),
            ],
          ),
        ),
      ),
    );
  }
}