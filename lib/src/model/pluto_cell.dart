import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoCell {
  PlutoCell({
    dynamic value,
    String? displayValue,
    Key? key,
  })  : _key = key ?? UniqueKey(),
        _value = value,
        _displayValue = displayValue;

  final Key _key;

  dynamic _value;
  dynamic _displayValue;

  dynamic get displayValue {
    if (_displayValue != null) {
      return _displayValue;
    } else {
      return value;
    }
  }

  set displayValue(dynamic changed) {
    if (_displayValue == changed) {
      return;
    }

    _displayValue = changed;
  }

  dynamic get value {
    if (_needToApplyFormatOnInit) {
      _applyFormatOnInit();
    }

    return _value;
  }

  dynamic _valueForSorting;

  bool _needToApplyFormatOnInit = false;

  PlutoColumn? _column;

  PlutoRow? _row;

  Key get key => _key;

  bool get initialized => _column != null && _row != null;

  PlutoColumn get column {
    _assertUnInitializedCell(_column != null);

    return _column!;
  }

  PlutoRow get row {
    _assertUnInitializedCell(_row != null);

    return _row!;
  }

  set value(dynamic changed) {
    if (_value == changed) {
      return;
    }

    _value = changed;

    _valueForSorting = null;
  }

  dynamic get valueForSorting {
    _valueForSorting ??= _getValueForSorting();

    return _valueForSorting;
  }

  void setColumn(PlutoColumn column) {
    _column = column;
    _valueForSorting = _getValueForSorting();
    _needToApplyFormatOnInit = _column?.type.applyFormatOnInit == true;
  }

  void setRow(PlutoRow row) {
    _row = row;
  }

  dynamic _getValueForSorting() {
    if (displayValue != null) {
      return displayValue;
    }
    if (_column == null) {
      return displayValue;
    }

    if (_needToApplyFormatOnInit) {
      _applyFormatOnInit();
    }

    return _column!.type.makeCompareValue(_value || displayValue);
  }

  void _applyFormatOnInit() {
    _value = _column!.type.applyFormat(_value);

    if (_column!.type is PlutoColumnTypeWithNumberFormat) {
      _value = (_column!.type as PlutoColumnTypeWithNumberFormat).toNumber(_value);
    }

    _needToApplyFormatOnInit = false;
  }
}

void _assertUnInitializedCell(bool flag) {
  assert(
    flag,
    'PlutoCell is not initialized.'
    'When adding a column or row, if it is not added through PlutoGridStateManager, '
    'PlutoCell does not set the necessary information at runtime.'
    'If you add a column or row through PlutoGridStateManager and this error occurs, '
    'please contact Github issue.',
  );
}
