import 'dart:async';

enum RadioButtonAction { True, False, Delete }

class RadioButtonBloc {
  late bool radioValue = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateRadioButtonSink => _stateStreamController.sink;
  Stream<bool> get stateRadioButtonStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<RadioButtonAction>();
  StreamSink<RadioButtonAction> get eventRadioButtonSink =>
      _eventStreamController.sink;
  Stream<RadioButtonAction> get _eventRadioButtonStrean =>
      _eventStreamController.stream;

  radioButtonBloc() {
    _eventRadioButtonStrean.listen((event) async {
      if (event == RadioButtonAction.True) {
        radioValue = true;
      } else if (event == RadioButtonAction.False) {
        radioValue = false;
      }

      print(radioValue);

      _stateRadioButtonSink.add(radioValue);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
