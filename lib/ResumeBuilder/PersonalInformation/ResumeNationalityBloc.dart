// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'ResumeNationalityResponse.dart';

enum ResumeNationalityAction { Post }

class ResumeNationalityBloc {
  final _stateStreamController = StreamController<List<String>>();
  List<String> nationalitycode = [];
  List<String> nationalityname = [];
  bool isFirst = true;
  var header;

  StreamSink<List<String>> get _stateResumeNationalitySink =>
      _stateStreamController.sink;
  Stream<List<String>> get stateResumenatioNalityStrean =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<ResumeNationalityAction>();
  StreamSink<ResumeNationalityAction> get eventResumeNationalitySink =>
      _eventStreamController.sink;
  Stream<ResumeNationalityAction> get _eventResumeNationalityStrean =>
      _eventStreamController.stream;

  ResumeNationalityBloc() {
    _eventResumeNationalityStrean.listen((event) async {
      if (event == ResumeNationalityAction.Post) {
        try {
          var response = await callgetResumenationalityapi();
          ResumeNationalityResponse getnationality =
              resumeNationalityResponseFromJson(response);
          for (int i = 0; i < getnationality.data.length; i++) {
            if (getnationality.data[i].nationalityName != "Indian") {
              nationalityname.add(getnationality.data[i].nationalityName);
              nationalitycode.add(getnationality.data[i].id.toString());
            }
          }
          for (int i = 0; i < getnationality.data.length; i++) {
            if (getnationality.data[i].nationalityName == "Indian") {
              nationalityname.insert(0, getnationality.data[i].nationalityName);
              nationalitycode.insert(0, getnationality.data[i].id.toString());
            }
          }
          _stateResumeNationalitySink.add(nationalityname);
        } on SocketException catch (e) {
          displaysnackbar('Please check your internet connection');
        } catch (e) {
          _stateResumeNationalitySink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetResumenationalityapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getnationality'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);

      return response.body;
    } catch (err) {
      return err.toString();
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
