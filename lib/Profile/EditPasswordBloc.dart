import 'dart:async';

enum EditPasswordAction { True, False }

class EditPasswordBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateEditPasswordSink => _stateStreamController.sink;
  Stream<bool> get stateEditPasswordStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<EditPasswordAction>();
  StreamSink<EditPasswordAction> get eventEditPasswordSink =>
      _eventStreamController.sink;
  Stream<EditPasswordAction> get _eventEditPasswordStrean =>
      _eventStreamController.stream;

  EditPasswordBloc() {
    _eventEditPasswordStrean.listen((event) async {
      if (event == EditPasswordAction.True)
        isedited = true;
      else if (event == EditPasswordAction.False) isedited = false;
      _stateEditPasswordSink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
