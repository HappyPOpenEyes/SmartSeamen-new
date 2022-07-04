import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'RegisterAPI.dart';

class RegisterProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callregisterapi(firstname, lastname, email, phonenumber,
      countryid, password, userid) async {
    var body = {
      "role_id": "3",
      "firstname": firstname,
      "lastname": lastname,
      "mobile": phonenumber,
      "country_id": countryid,
      "email": email,
      "password": password,
      "id": userid
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

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        RegisterApi registerApi = registerApiFromJson(response.body);

        prefs.setString('registerstatus', registerApi.message);
        prefs.setString('registeruserid', registerApi.data);
        return success = true;
      } else if (response.statusCode == 422) {
        prefs.setString(
            'registerstatus', 'The email or mobile has already been taken');
        return success = false;
      } else {
        prefs.setString('registerstatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
