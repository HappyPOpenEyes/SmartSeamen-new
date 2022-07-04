import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Register/RegisterAPI.dart';
import '../constants.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callforgotpasswordapi(email) async {
    var body = {
      "email": email,
    };
    try {
      var response = await http.post(Uri.parse(apiurl + '/forgot'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        RegisterApi registerApi = registerApiFromJson(response.body);
        prefs.setString('forgotpasswordstatus', registerApi.message);
        return success = true;
      } else if (response.statusCode == 404) {
        prefs.setString('forgotpasswordstatus', 'Invalid email');
        return success = false;
      } else {
        prefs.setString('forgotpasswordstatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
