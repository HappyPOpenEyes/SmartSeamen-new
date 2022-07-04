// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'GetEngineResponse.dart';

enum EngineAction { Post }

class EngineBloc {
  final _stateStreamController = StreamController<List<String>>.broadcast();
  List<String> enginename = [];
  List<String> engineid = [];
  bool showEngine = true;
  var header;

  StreamSink<List<String>> get _stateEngineSink => _stateStreamController.sink;
  Stream<List<String>> get stateEngineStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<EngineAction>();
  StreamSink<EngineAction> get eventEngineSink => _eventStreamController.sink;
  Stream<EngineAction> get _eventEngineStrean => _eventStreamController.stream;

  EngineBloc() {
    _eventEngineStrean.listen((event) async {
      if (event == EngineAction.Post) {
        try {
          var response = await callgetEngineapi();
          GetEngineResponse getEngineResponse =
              getEngineResponseFromJson(response);
          if (engineid.isEmpty) {
            for (int i = 0; i < getEngineResponse.data.length; i++) {
              enginename.add(getEngineResponse.data[i].engineName);
              engineid.add(getEngineResponse.data[i].id);
            }
          }
          _stateEngineSink.add(enginename);
        } catch (e) {
          _stateEngineSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetEngineapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getengine'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);

      return response.body;
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
