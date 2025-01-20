import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/resources/shared_preferences_resources.dart';

class SharedPreferencesSeatCushionDataSaveOptionProvider {
  final StreamController<SeatCushionSaveOptions> _optionsStreamController = StreamController.broadcast();
  final SharedPreferences sharedPreferences;
  static bool _fetchOption({
    required SharedPreferences sharedPreferences,
    required String key,
  }) {
    return sharedPreferences.getBool(key) ?? true;
  }
  Stream<SeatCushionSaveOptions> get optionsStream => _optionsStreamController.stream;
  SeatCushionSaveOptions _options;
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
