import 'dart:async';

enum EditQuestionsAction { True, False }

class EditQuestionsBloc {
  bool isedited = false;
  final _stateStreamController = StreamController<bool>.broadcast();

  StreamSink<bool> get _stateEditQuestionsSink => _stateStreamController.sink;
  Stream<bool> get stateEditQuestionsStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<EditQuestionsAction>();
  StreamSink<EditQuestionsAction> get eventEditQuestionsSink =>
      _eventStreamController.sink;
  Stream<EditQuestionsAction> get _eventEditQuestionsStrean =>
      _eventStreamController.stream;

  EditQuestionsBloc() {
    _eventEditQuestionsStrean.listen((event) async {
      if (event == EditQuestionsAction.True)
        isedited = true;
      else if (event == EditQuestionsAction.False) isedited = false;
      _stateEditQuestionsSink.add(isedited);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
