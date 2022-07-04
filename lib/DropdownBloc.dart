// ignore_for_file: constant_identifier_names

import 'dart:async';

enum DropdownAction { Get, Update, Delete }

class DropdownBloc {
  String? dropdownvalue = "";
  final _stateStreamController = StreamController<String>.broadcast();

  StreamSink<String> get _stateDropdownSink => _stateStreamController.sink;
  Stream<String> get stateDropdownStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<DropdownAction>();
  StreamSink<DropdownAction> get eventDropdownSink =>
      _eventStreamController.sink;
  Stream<DropdownAction> get _eventDropdownStrean =>
      _eventStreamController.stream;

  setdropdownvalue(value) => dropdownvalue = value;

  String? get getdropdownvalue => dropdownvalue;

  DropdownBloc() {
    _eventDropdownStrean.listen((event) async {
      if (event == DropdownAction.Delete) dropdownvalue = "";

      _stateDropdownSink.add(dropdownvalue ?? "");
    });
  }

  void dispose() {
    dropdownvalue = "";
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
