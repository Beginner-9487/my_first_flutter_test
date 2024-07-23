import 'dart:async';

import 'package:utl_leakage/application/domain/leakage_repository.dart';

class CheckWarningUseCase {
  LeakageRepository _repository;
  CheckWarningUseCase(this._repository);
  bool get isExtraLeakage => (_repository.rows.isNotEmpty) ? _repository.rows.last.isExtraLeakage : false;
  bool get isIntraOsmosis => (_repository.rows.isNotEmpty) ? _repository.rows.last.isIntraOsmosis : false;
  StreamSubscription onExtraLeakage(void Function(bool isExtraLeakage) doSomething) {
    return _repository.onAdd((row) {
      doSomething(row.isExtraLeakage);
    });
  }
  StreamSubscription onIntraOsmosis(void Function(bool isIntraOsmosis) doSomething) {
    return _repository.onAdd((row) {
      doSomething(row.isIntraOsmosis);
    });
  }
}