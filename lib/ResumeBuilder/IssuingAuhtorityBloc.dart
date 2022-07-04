// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'IssuingAuthorityResponse.dart';

enum ResumeIssuingAuthorityAction { Post }

class ResumeIssuingAuthorityBloc {
  final _stateStreamController = StreamController<bool>.broadcast();
  List<String> countrycode = [];
  List<String> countryname = [];
  bool showIssue = false;
  var header;

  StreamSink<bool> get _stateResumeIssuingAuthoritySink =>
      _stateStreamController.sink;
  Stream<bool> get stateResumeIssuingAuthorityStrean =>
      _stateStreamController.stream;

  final _eventStreamController =
      StreamController<ResumeIssuingAuthorityAction>();
  StreamSink<ResumeIssuingAuthorityAction>
      get eventResumeIssuingAuthoritySink => _eventStreamController.sink;
  Stream<ResumeIssuingAuthorityAction> get _eventResumeIssuingAuthorityStrean =>
      _eventStreamController.stream;

  ResumeIssuingAuthorityBloc() {
    _eventResumeIssuingAuthorityStrean.listen((event) async {
      if (event == ResumeIssuingAuthorityAction.Post) {
        if (countrycode.isEmpty) {
          try {
            var response = await callgetResumeIssuingAuthorityapi();
            IssuingAuthorityResponse getIssuingAuthority =
                issuingAuthorityResponseFromJson(response);
            for (int i = 0; i < getIssuingAuthority.data.length; i++) {
              if (getIssuingAuthority.data[i].issueName != "India") {
                countryname.add(getIssuingAuthority.data[i].issueName);
                countrycode.add(getIssuingAuthority.data[i].id.toString());
              }
            }
            for (int i = 0; i < getIssuingAuthority.data.length; i++) {
              if (getIssuingAuthority.data[i].issueName == "India") {
                countryname.insert(0, getIssuingAuthority.data[i].issueName);
                countrycode.insert(
                    0, getIssuingAuthority.data[i].id.toString());
              }
            }

            _stateResumeIssuingAuthoritySink.add(true);
          } catch (e) {
            _stateResumeIssuingAuthoritySink.addError('Something went wrong');
          }
        } else {
          _stateResumeIssuingAuthoritySink.add(true);
        }
      }
    });
  }

  Future<String> callgetResumeIssuingAuthorityapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getissuing'),
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
