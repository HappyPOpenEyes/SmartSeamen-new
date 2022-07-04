import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'VerifyEmailResponse.dart';

class ForgotEmailMobileVerifyProvider extends ChangeNotifier {
  bool success = false;
  late String userid;
  dynamic statusCode;
  Future<bool> callMobileVerifyapi(mobile) async {
    var body = {"mobile": mobile};
    print(body);
    try {
      var response = await http.post(Uri.parse('$apiurl/forgotemail'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        VerifyNumberResponse verifyNumberResponse =
            verifyNumberResponseFromJson(response.body);
        userid = verifyNumberResponse.data;
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