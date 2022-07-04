import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumePersonalInfoUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostResumeprofileapi(
      firstname,
      lastname,
      phonenumber,
      email,
      countryid,
      alternativecountryid,
      alternamemobile,
      dob,
      userid,
      header) async {
    var body = {
      "firstname": firstname,
      "lastname": lastname,
      "mobile": phonenumber,
      "email": email,
      "country_id": countryid,
      "alternate_country_id": alternativecountryid,
      "alternate_mobile_no": alternamemobile,
      "id": userid,
      "dob": dob
    };
    try {
      var response = await http.post(Uri.parse('$apiurl/resume/accountedit'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);

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
      error = err.toString();
      return success = false;
    }
  }
}
