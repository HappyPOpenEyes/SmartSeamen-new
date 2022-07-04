import 'dart:async';

enum ResumeErrorIssuingAuthorityAction { True, False }

class ResumeErrorIssuingAuthorityBloc {
  bool showtext = false, showAlternateText = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateResumeIssuingAuthoritySink =>
      _stateStreamController.sink;
  Stream<bool> get stateResumeIssuingAuthorityStrean =>
      _stateStreamController.stream;

  final _eventStreamController =
      StreamController<ResumeErrorIssuingAuthorityAction>();
  StreamSink<ResumeErrorIssuingAuthorityAction>
      get eventResumeIssuingAuthoritySink => _eventStreamController.sink;
  Stream<ResumeErrorIssuingAuthorityAction>
      get _eventResumeIssuingAuthorityStrean => _eventStreamController.stream;

  ResumeErrorIssuingAuthorityBloc() {
    _eventResumeIssuingAuthorityStrean.listen((event) async {
      if (event == ResumeErrorIssuingAuthorityAction.True) {
        _stateResumeIssuingAuthoritySink.add(showtext = true);
      } else {
        _stateResumeIssuingAuthoritySink.add(showtext = false);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
