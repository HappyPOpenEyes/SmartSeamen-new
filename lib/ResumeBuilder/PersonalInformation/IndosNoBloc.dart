import 'dart:async';

// ignore: constant_identifier_names
enum IndosNoAction { True, False }

class IndosNoBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateIndosNoSink => _stateStreamController.sink;
  Stream<bool> get stateIndosNoStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<IndosNoAction>();
  StreamSink<IndosNoAction> get eventIndosNoSink =>
      _eventStreamController.sink;
  Stream<IndosNoAction> get _eventIndosNoStrean =>
      _eventStreamController.stream;

  IndosNoBloc() {
    _eventIndosNoStrean.listen((event) async {
      if (event == IndosNoAction.True) {
        isedited = true;
      } else if (event == IndosNoAction.False) {
        isedited = false;
      }
      _stateIndosNoSink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
