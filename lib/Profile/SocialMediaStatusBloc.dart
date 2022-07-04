import 'dart:async';

enum SocialMediaStatusAction { True, False, Delete }

class SocialMediaStatusBloc {
  bool statusValue = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateSocialMediaStatusSink =>
      _stateStreamController.sink;
  Stream<bool> get stateSocialMediaStatusStrean =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<SocialMediaStatusAction>();
  StreamSink<SocialMediaStatusAction> get eventSocialMediaStatusSink =>
      _eventStreamController.sink;
  Stream<SocialMediaStatusAction> get _eventSocialMediaStatusStrean =>
      _eventStreamController.stream;

  SocialMediaStatusBloc() {
    _eventSocialMediaStatusStrean.listen((event) async {
      if (event == SocialMediaStatusAction.True) {
        statusValue = true;
      } else if (event == SocialMediaStatusAction.False) {
        statusValue = false;
      }

      _stateSocialMediaStatusSink.add(statusValue);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
