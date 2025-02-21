import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/adapter/file/file_manager.dart';
import 'package:utl_electrochemical_tester/adapter/local_storage/electrochemical_command_local_storage_handler.dart';

class AdapterResource {
  AdapterResource._();
  static late final ElectrochemicalDevicesManager electrochemicalDevicesManager;
  static late final FileManager fileManager;
  static late final ElectrochemicalCommandLocalStorageHandler electrochemicalCommandLocalStorageHandler;
}
