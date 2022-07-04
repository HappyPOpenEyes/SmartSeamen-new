import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

// ignore: constant_identifier_names
enum RegisterAction { Post }

class RegisterBloc {
  final _stateStreamController = StreamController<String>();

  var firstname = "",
      lastname = "",
      email = "",
      password = "",
      phonenumber = "";
  String setfirstname(text) => firstname = text;
  String setlastname(text) => lastname = text;
  String setemail(text) => email = text;
  String setphonenumber(text) => phonenumber = text;
  String setpassword(text) => password = text;

  StreamSink<String> get _registerSink => _stateStreamController.sink;
  Stream<String> get registerStrean => _stateStreamController.stream;

  final _eventStreamController = StreamController<RegisterAction>();
  StreamSink<RegisterAction> get eventSink => _eventStreamController.sink;
  Stream<RegisterAction> get eventStrean => _eventStreamController.stream;

  RegisterBloc() {
    eventStrean.listen((event) async {
      if (event == RegisterAction.Post) {
        try {
          var response = await callregisterapi();
          _registerSink.add(response);
        } catch (e) {
          _registerSink.addError('Something went wrong');
        }
      }
    });
  }

  Future<String> callregisterapi() async {
    var body = {
      "role_id": 3,
      "firstname": firstname,
      "lastname": lastname,
      "mobile": phonenumber,
      "email": email,
      "password": password
    };
    try {
      var response = await http.post(Uri.parse('$apiurl/register'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          encoding: Encoding.getByName("utf-8"));

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
