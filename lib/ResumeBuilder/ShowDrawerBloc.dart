import 'dart:async';

enum ShowDrawerAction { Show, Hide }

class ShowDrawerBloc {
  final _stateStreamController = StreamController<bool>.broadcast();
  bool showDrawer = false;

  StreamSink<bool> get _stateShowDrawerSink => _stateStreamController.sink;
  Stream<bool> get stateShowDrawerStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<ShowDrawerAction>();
  StreamSink<ShowDrawerAction> get eventShowDrawerSink =>
      _eventStreamController.sink;
  Stream<ShowDrawerAction> get _eventShowDrawerStrean =>
      _eventStreamController.stream;

  ShowDrawerBloc() {
    _eventShowDrawerStrean.listen((event) async {
      if (event == ShowDrawerAction.Show)
        showDrawer = true;
      else
        showDrawer = false;
      _stateShowDrawerSink.add(showDrawer);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
