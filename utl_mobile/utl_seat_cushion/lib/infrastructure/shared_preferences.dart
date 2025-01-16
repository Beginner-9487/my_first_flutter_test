import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_seat_cushion/domain/data/seat_cushion_data.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';
import 'package:utl_seat_cushion/resources/shared_preferences_resources.dart';

class SharedPreferencesSeatCushionDataSaveOptionProvider implements SeatCushionSaveOptionsProvider {
  final StreamController<SeatCushionSaveOptions> _optionsStreamController = StreamController.broadcast();
  final SharedPreferences sharedPreferences;
  static bool _fetchOption({
    required SharedPreferences sharedPreferences,
    required String key,
  }) {
    return sharedPreferences.getBool(key) ?? true;
  }
  @override
  Stream<SeatCushionSaveOptions> get optionsStream => _optionsStreamController.stream;
  SeatCushionSaveOptions _options;
  @override
  SeatCushionSaveOptions get options => _options;
  Future<void> saveToSharedPreferences({
    required SeatCushionSaveOptions options,
  }) async {
    await sharedPreferences.setBool(
      SharedPreferencesResources.saveToBufferOption,
      options.saveToBufferOption,
    );
    await sharedPreferences.setBool(
      SharedPreferencesResources.saveToDatabaseOption,
      options.saveToDatabaseOption,
    );
  }
  @override
  set options(SeatCushionSaveOptions options) {
    saveToSharedPreferences(options: options);
    _options = options;
    _optionsStreamController.add(options);
  }
  SharedPreferencesSeatCushionDataSaveOptionProvider({
    required this.sharedPreferences,
  }) : _options = SeatCushionSaveOptions(
    saveToBufferOption: _fetchOption(
      sharedPreferences: sharedPreferences,
      key: SharedPreferencesResources.saveToBufferOption,
    ),
    saveToDatabaseOption: _fetchOption(
      sharedPreferences: sharedPreferences,
      key: SharedPreferencesResources.saveToDatabaseOption,
    ),
  ) {
    _optionsStreamController.add(options);
  }
  void dispose() {
    _optionsStreamController.close();
  }
}
