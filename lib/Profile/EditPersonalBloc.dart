import 'dart:async';

enum EditPersonalAction { True, False }

class EditPersonalBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateEditPersonalSink => _stateStreamController.sink;
  Stream<bool> get stateEditPersonalStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<EditPersonalAction>();
  StreamSink<EditPersonalAction> get eventEditPersonalSink =>
      _eventStreamController.sink;
  Stream<EditPersonalAction> get _eventEditPersonalStrean =>
      _eventStreamController.stream;

  EditPersonalBloc() {
    _eventEditPersonalStrean.listen((event) async {
      if (event == EditPersonalAction.True)
        isedited = true;
      else if (event == EditPersonalAction.False) isedited = false;
      _stateEditPersonalSink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
