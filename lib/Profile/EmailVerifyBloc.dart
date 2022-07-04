import 'dart:async';

enum EmailVerifyAction { True, False }

class EmailVerifyBloc {
  bool emailVerifyvalue = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateEmailVerifySink => _stateStreamController.sink;
  Stream<bool> get stateEmailVerifyStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<EmailVerifyAction>();
  StreamSink<EmailVerifyAction> get eventEmailVerifySink =>
      _eventStreamController.sink;
  Stream<EmailVerifyAction> get _eventEmailVerifyStrean =>
      _eventStreamController.stream;

  EmailVerifyBloc() {
    _eventEmailVerifyStrean.listen((event) async {
      if (event == EmailVerifyAction.True) {
        emailVerifyvalue = true;
      } else if (event == EmailVerifyAction.False) {
        emailVerifyvalue = false;
      }
      _stateEmailVerifySink.add(emailVerifyvalue);
    });
  }

  void dispose() {
    emailVerifyvalue = false;
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
