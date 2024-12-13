import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_context_resource/context_resource_impl.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_file_handler/row_csv_file_impl.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:flutter_system_path/system_path_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/impl/bluetooth_scanner_controller_impl_fbp.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/impl/bluetooth_scanner_device_tile_controller_impl_fbp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_aggregate.dart';
import 'package:utl_electrochemical_tester/application/infrastructure/save_file_while_finish.dart';
import 'package:utl_electrochemical_tester/application/repository/csv_file_repository.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_aggregate_handler.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data_factory_impl.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data_listener.dart';
import 'package:utl_electrochemical_tester/presentation/screen/home_screen.dart';
import 'package:utl_electrochemical_tester/resources/app_theme.dart';
import 'package:utl_electrochemical_tester/resources/bt_uuid.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler_impl_fbp.dart';
import 'package:utl_mobile/utl_data_converter/utl_bytes_to_data.dart';
import 'package:utl_mobile/utl_data_converter/utl_bytes_to_data_impl.dart';
import 'package:utl_mobile/utl_data_converter/utl_data_to_bytes.dart';
import 'package:utl_mobile/utl_data_converter/utl_data_to_bytes_impl.dart';

@pragma('vm:entry-point')
void startCallback() {
}

late final SharedPreferences sharedPreferences;
late final SystemPath systemPath;

// late final Electrochemical_File_Data_Factory electrochemical_file_data_factory;
// late final Electrochemical_UI_Data_Factory electrochemical_ui_data_factory;
//
// late final UTL_Bytes_to_Data utl_bytes_to_data;
// late final UTL_Data_To_Bytes utl_data_to_bytes;

// late final UTL_BT_Handler? utl_bt_handler;
late final BluetoothDevicesService? bt_event_handler;

late final RowCSVFileHandler rowCSVFileHandler;
// Electrochemical_File_Repository? electrochemical_file_repository;
// Save_File_While_Finish? save_file_while_finish;

void main() async {
  BluetoothScannerControllerImplFbp<BluetoothScannerDeviceTileController> bluetoothScannerManagerImplFbp = BluetoothScannerControllerImplFbp(
      scanDuration: const Duration(seconds: 15),
      bluetoothDeviceToDevice: (bluetoothDevice) => BluetoothScannerDeviceTileControllerImplFbp.createByBluetoothDevice(
          bluetoothDevice: bluetoothDevice,
          isConnectable: false,
          rssi: 0,
      ),
      scanResultToDevice: (scanResult) => BluetoothScannerDeviceTileControllerImplFbp.createByScanResult(scanResult: scanResult),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Bloc.observer = GlobalBlocObserver();

  sharedPreferences = await SharedPreferences.getInstance();
  systemPath = await SystemPathImpl.getInstance();
  bt_provider = BT_Provider_Impl_FBP.init();

  utl_bytes_to_data = UTL_Bytes_to_Data_Impl();
  utl_data_to_bytes = UTL_Data_To_Bytes_Impl();

  rowCSVFileHandler = RowCSVFileHandlerImpl.getInstance();

  electrochemical_aggregate_impl = Electrochemical_Aggregate_Impl();
  electrochemical_aggregate_handler = Electrochemical_Aggregate_Handler_Impl(
    aggregate: electrochemical_aggregate_impl,
  );

  utl_bt_handler = UTL_BT_Handler_Impl.init(
    bt_provider: bt_provider,
    input_UUID: [bluetoothInputUuids],
    output_UUID: [bluetoothOutputUuids],
  );
  bt_event_handler = BT_Event_Handler_Impl(
    electrochemical_aggregate_handler: electrochemical_aggregate_handler,
    utl_bytes_to_data: utl_bytes_to_data,
    utl_bt_handler: utl_bt_handler!,
    utl_data_to_bytes: utl_data_to_bytes,
  );

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    rootContextResource = ContextResourceImpl(context);
    electrochemical_file_data_factory = Electrochemical_File_Data_Factory_Impl(
        rootContextResource,
        electrochemical_aggregate_handler,
    );
    electrochemical_ui_data_factory = Electrochemical_UI_Data_Factory_Impl(
        rootContextResource,
        electrochemical_aggregate_handler,
    );
    final ElectrochemicalCommandController bt_controller = BT_Controller_Impl(bt_event_handler: bt_event_handler!);
    final Electrochemical_Data_Listener electrochemical_data_listener = Electrochemical_Data_Listener_Impl(
        contextResource: rootContextResource,
        electrochemical_aggregate_handler: electrochemical_aggregate_handler,
        electrochemical_file_data_factory: electrochemical_file_data_factory,
        electrochemical_ui_data_factory: electrochemical_ui_data_factory,
    );
    electrochemical_file_repository ??= Electrochemical_File_Repository_Impl(
        _context: rootContextResource,
        rowCSVFileHandler: rowCSVFileHandler,
        systemPath: systemPath
    );
    save_file_while_finish ??= Save_File_While_Finish_Impl(
      electrochemical_data_listener: electrochemical_data_listener,
      electrochemical_file_repository: electrochemical_file_repository!,
    );
    final ElectrochemicalLineChartController electrochemical_line_chart_controller = Electrochemical_Line_Chart_Controller_Impl(
      contextResource: rootContextResource,
      electrochemical_data_listener: electrochemical_data_listener,
    );
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: AppTheme.primaryColor,
      ),
      home: HomeScreen(
        bt_controller: bt_controller,
        _context: rootContextResource,
        electrochemical_line_chart_controller: electrochemical_line_chart_controller,
        sharedPreferences: sharedPreferences,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}