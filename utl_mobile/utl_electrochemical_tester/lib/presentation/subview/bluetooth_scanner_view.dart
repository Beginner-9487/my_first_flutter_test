import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_scanner_view_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_tile/bluetooth_tile_impl_buttons_text.dart';
import 'package:utl_electrochemical_tester/application/controller/bt_controller.dart';

abstract class Bluetooth_Scanner_View extends StatefulWidget {
  const Bluetooth_Scanner_View({super.key});
}

class Bluetooth_Scanner_View_Impl extends Bluetooth_Scanner_View {
  final BT_Controller bt_controller;
  final ContextResource contextResource;
  Bluetooth_Scanner_View_Impl({
    super.key,
    required this.bt_controller,
    required this.contextResource,
  });
  late BluetoothScannerViewImpl bluetoothScannerViewImpl;
  @override
  State<Bluetooth_Scanner_View_Impl> createState() => _Bluetooth_Scanner_View_Impl_State();
}

class _Bluetooth_Scanner_View_Impl_State<View extends Bluetooth_Scanner_View_Impl> extends State<View> {
  BT_Controller get bt_controller => widget.bt_controller;
  ContextResource get contextResource => widget.contextResource;
  bool _block_if_text_is_empty(String text) {
    if (text != "") {
      return false;
    }
    AwesomeDialog(
      context: contextResource.context,
      dialogType: DialogType.error,
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
      width: 280,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(contextResource.context).showSnackBar(
          SnackBar(
            content: Text('Dismissed by $type'),
          ),
        );
      },
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: contextResource.str.name,
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
    return true;
  }
  @override
  void initState() {
    super.initState();
    widget.bluetoothScannerViewImpl = BluetoothScannerViewImpl(
        provider: bt_controller.bt_provider,
        filter: (device) => device.name.isNotEmpty,
        tileCreator: (device) {
          return BluetoothTileImplButtonsText(
            device: device,
            colorConnected: Colors.blue,
            colorDisconnected: Colors.red,
            textConnected: contextResource.str.disconnect,
            textDisconnected: contextResource.str.connect,
            onPressConnected: (device) {
              bt_controller.disconnect(device);
            },
            onPressDisconnected: (device) {
              bt_controller.connect(device);
            },
            textDefault: bt_controller.getName(device),
            buttons: {
              const Icon(Icons.heart_broken): (device, text) {
                if(_block_if_text_is_empty(text)) {
                  return;
                }
                bt_controller.setName(device, text);
                bt_controller.startHumanTrials(device);
              },
              const Icon(Icons.microwave): (device, text) {
                if(_block_if_text_is_empty(text)) {
                  return;
                }
                bt_controller.setName(device, text);
                bt_controller.startVirusDetector(device);
              },
            },
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return widget.bluetoothScannerViewImpl;
  }
}