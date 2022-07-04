import 'dart:async';

enum MobileVerifyAction { True, False }

class MobileVerifyBloc {
  bool mobileVerifyvalue = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateMobileVerifySink => _stateStreamController.sink;
  Stream<bool> get stateMobileVerifyStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<MobileVerifyAction>();
  StreamSink<MobileVerifyAction> get eventMobileVerifySink =>
      _eventStreamController.sink;
  Stream<MobileVerifyAction> get _eventMobileVerifyStrean =>
      _eventStreamController.stream;

  MobileVerifyBloc() {
    _eventMobileVerifyStrean.listen((event) async {
      if (event == MobileVerifyAction.True)
        mobileVerifyvalue = true;
      else if (event == MobileVerifyAction.False) mobileVerifyvalue = false;
      _stateMobileVerifySink.add(mobileVerifyvalue);
    });
  }

  void dispose() {
    mobileVerifyvalue = false;
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
