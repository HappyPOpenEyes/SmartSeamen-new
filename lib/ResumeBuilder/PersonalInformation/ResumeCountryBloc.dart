// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'GetResumeCountryResponse.dart';

enum ResumeCountriesAction { Post }

class ResumeCountriesBloc {
  final _stateStreamController = StreamController<List<String>>.broadcast();
  List<String> countrycode = [];
  List<String> countryname = [];
  var header;

  StreamSink<List<String>> get _stateResumeCountriesSink =>
      _stateStreamController.sink;
  Stream<List<String>> get stateResumeCountriesStrean =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<ResumeCountriesAction>();
  StreamSink<ResumeCountriesAction> get eventResumeCountriesSink =>
      _eventStreamController.sink;
  Stream<ResumeCountriesAction> get _eventResumeCountriesStrean =>
      _eventStreamController.stream;

  ResumeCountriesBloc() {
    _eventResumeCountriesStrean.listen((event) async {
      if (event == ResumeCountriesAction.Post) {
        try {
          var response = await callgetResumecountriesapi();
          GetResumeCountryResponse getCountries =
              getResumeCountryResponseFromJson(response);
          for (int i = 0; i < getCountries.data.length; i++) {
            if (getCountries.data[i].countryName != "India") {
              countryname.add(getCountries.data[i].countryName);
              countrycode.add(getCountries.data[i].id.toString());
            }
          }
          for (int i = 0; i < getCountries.data.length; i++) {
            if (getCountries.data[i].countryName == "India") {
              countryname.insert(0, getCountries.data[i].countryName);
              countrycode.insert(0, getCountries.data[i].id.toString());
            }
          }
          _stateResumeCountriesSink.add(countryname);
        } catch (e) {
          _stateResumeCountriesSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetResumecountriesapi() async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getcountry'),
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
