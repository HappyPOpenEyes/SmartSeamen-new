import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'LoginResponse.dart';

class LoginProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callloginapi(email, password, fcmToken) async {
    var body = {
      "email": email,
      "password": password,
      "role_id": "3",
      "registraion_ids": fcmToken
    };
    print(body);
    try {
      var response = await http.post(Uri.parse('$apiurl/login'),
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
        LoginResponse loginResponseApi = loginResponseFromJson(response.body);

        prefs.setString('loginstatus', loginResponseApi.message);
        prefs.setString('tokenheader', loginResponseApi.data.accessToken);
        prefs.setString(
            'header', "Bearer " + loginResponseApi.data.accessToken);
        return success = true;
      } else if (response.statusCode == 422) {
        prefs.setString('loginstatus', 'Invalid Credentials.');
        return success = false;
      } else {
        prefs.setString('loginstatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
