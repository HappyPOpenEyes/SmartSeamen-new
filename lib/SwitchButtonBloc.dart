import 'dart:async';

enum SwitchButtonAction { True, False }

class SwitchButtonBloc {
  bool switchValue = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateSwitchButtonSink => _stateStreamController.sink;
  Stream<bool> get stateSwitchButtonStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<SwitchButtonAction>();
  StreamSink<SwitchButtonAction> get eventSwitchButtonSink =>
      _eventStreamController.sink;
  Stream<SwitchButtonAction> get _eventSwitchButtonStrean =>
      _eventStreamController.stream;
  
  

  SwitchButtonBloc() {
    _eventSwitchButtonStrean.listen((event) async {
      if (event == SwitchButtonAction.True)
        switchValue = true;
      else if (event == SwitchButtonAction.False) switchValue = false;
      _stateSwitchButtonSink.add(switchValue);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
