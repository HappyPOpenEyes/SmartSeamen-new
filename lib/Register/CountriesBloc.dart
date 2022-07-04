// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:http/http.dart' as http;

import '../constants.dart';
import 'CountriesList.dart';

enum PhoneCountriesAction { Post, Update }

class PhoneCountriesBloc {
  final _stateStreamController = StreamController<List<String>>.broadcast();
  List<String> countrycode = [];
  List<String> countryname = [];
  List<String> countryId = [], countryprefixcode = [];

  StreamSink<List<String>> get _stateCountriesSink =>
      _stateStreamController.sink;
  Stream<List<String>> get stateCountriesStrean =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<PhoneCountriesAction>();
  StreamSink<PhoneCountriesAction> get eventCountriesSink =>
      _eventStreamController.sink;
  Stream<PhoneCountriesAction> get _eventCountriesStrean =>
      _eventStreamController.stream;

  PhoneCountriesBloc() {
    _eventCountriesStrean.listen((event) async {
      if (event == PhoneCountriesAction.Post) {
        try {
          var response = await callgetcountriesapi();
          GetCountries getCountries = getCountriesFromJson(response);
          if (countryId.isEmpty) {
            for (int i = 0; i < getCountries.data.length; i++) {
              if (getCountries.data[i].phonePrefix != "91") {
                countrycode.add("${getCountries.data[i].countryName} (${getCountries.data[i].phonePrefix})");
                countryname.add(getCountries.data[i].countryName);
                countryprefixcode.add(getCountries.data[i].phonePrefix);
                countryId.add(getCountries.data[i].id.toString());
              }
            }
            for (int i = 0; i < getCountries.data.length; i++) {
              if (getCountries.data[i].phonePrefix == "91") {
                countrycode.insert(
                    0,
                    "${getCountries.data[i].countryName} (${getCountries.data[i].phonePrefix})");
                countryname.insert(0, getCountries.data[i].countryName);
                countryprefixcode.insert(0, getCountries.data[i].phonePrefix);
                countryId.insert(0, getCountries.data[i].id.toString());
              }
            }
          }
          _stateCountriesSink.add(countrycode);
        } catch (e) {
          _stateCountriesSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callgetcountriesapi() async {
    countrycode = [];
    countryname = [];
    countryId = [];
    countryprefixcode = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/country'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      // ignore: avoid_print
      print(response.statusCode);

      return response.body;
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
      return err.toString();
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
