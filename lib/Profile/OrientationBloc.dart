import 'dart:async';

enum ChangeOrientationAction { True, False }

class ChangeOrientationBloc {
  bool isPotrait = true;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateChangeOrientationSink => _stateStreamController.sink;
  Stream<bool> get stateChangeOrientationStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<ChangeOrientationAction>();
  StreamSink<ChangeOrientationAction> get eventChangeOrientationSink =>
      _eventStreamController.sink;
  Stream<ChangeOrientationAction> get _eventChangeOrientationStrean =>
      _eventStreamController.stream;

  ChangeOrientationBloc() {
    _eventChangeOrientationStrean.listen((event) async {
      if (event == ChangeOrientationAction.True)
        isPotrait = true;
      else if (event == ChangeOrientationAction.False) isPotrait = false;
      _stateChangeOrientationSink.add(isPotrait);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
