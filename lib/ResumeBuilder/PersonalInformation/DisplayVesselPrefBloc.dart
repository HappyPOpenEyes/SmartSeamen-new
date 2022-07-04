import 'dart:async';

enum DisplayVesselPrefAction { True, False }

class DisplayVesselPrefBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>();

  StreamSink<bool> get _stateDisplayVesselPrefSink => _stateStreamController.sink;
  Stream<bool> get stateDisplayVesselPrefStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<DisplayVesselPrefAction>();
  StreamSink<DisplayVesselPrefAction> get eventDisplayVesselPrefSink =>
      _eventStreamController.sink;
  Stream<DisplayVesselPrefAction> get _eventDisplayVesselPrefStrean =>
      _eventStreamController.stream;

  DisplayVesselPrefBloc() {
    _eventDisplayVesselPrefStrean.listen((event) async {
      if (event == DisplayVesselPrefAction.True)
        isedited = true;
      else if (event == DisplayVesselPrefAction.False) isedited = false;
      _stateDisplayVesselPrefSink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
