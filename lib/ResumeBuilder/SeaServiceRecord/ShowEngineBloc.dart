import 'dart:async';

enum ShowEngineAction { True, False }

class ShowEngineBloc {
  final _stateStreamController = StreamController<bool>.broadcast();
  bool showEngine = false;
  var header;

  StreamSink<bool> get _stateShowEngineSink => _stateStreamController.sink;
  Stream<bool> get stateShowEngineStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<ShowEngineAction>();
  StreamSink<ShowEngineAction> get eventShowEngineSink =>
      _eventStreamController.sink;
  Stream<ShowEngineAction> get _eventShowEngineStrean =>
      _eventStreamController.stream;

  ShowEngineBloc() {
    _eventShowEngineStrean.listen((event) async {
      if (event == ShowEngineAction.True) {
        showEngine = true;
        _stateShowEngineSink.add(showEngine);
      } else {
        showEngine = false;
        _stateShowEngineSink.add(showEngine);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
