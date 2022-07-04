import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class PersonalInfoUpdateProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callpostprofileapi(firstname, lastname, phonenumber, email,
      alternateemail, userid, header) async {
    var body = {
      "firstname": firstname,
      "lastname": lastname,
      "mobile": phonenumber,
      "email": email,
      "alternate_email": alternateemail,
      "id": userid
    };

    print(body);
    try {
      var response = await http.post(Uri.parse(apiurl + '/resume/accountedit'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        // GetProfileResponse profileResponseApi = getProfileResponseFromJson(response.body);
        // prefs.setString('profilestatus', profileResponseApi.message);
        return success = true;
      } else if (response.statusCode == 422) {
        //prefs.setString('profilestatus', 'Invalid Credentials.');
        return success = false;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
