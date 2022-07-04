import 'dart:async';

enum OtherCountryAction { True, False }

class OtherCountryBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>();

  StreamSink<bool> get _stateOtherCountrySink => _stateStreamController.sink;
  Stream<bool> get stateOtherCountryStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<OtherCountryAction>();
  StreamSink<OtherCountryAction> get eventOtherCountrySink =>
      _eventStreamController.sink;
  Stream<OtherCountryAction> get _eventOtherCountryStrean =>
      _eventStreamController.stream;

  OtherCountryBloc() {
    _eventOtherCountryStrean.listen((event) async {
      if (event == OtherCountryAction.True)
        isedited = true;
      else if (event == OtherCountryAction.False) isedited = false;
      _stateOtherCountrySink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
