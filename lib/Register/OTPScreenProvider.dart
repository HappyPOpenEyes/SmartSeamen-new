import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'OtpVerifyResponse.dart';

class OTPScreenProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callotpverifyapi(otp, userid) async {
    var body = {
      "id": userid,
      "otp": otp,
      "status": 1
    };
    
    try {
      var response = await http.post(Uri.parse(apiurl + '/verify'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        prefs.clear();
        OtpVerifyResponse verifyApi = otpVerifyResponseFromJson(response.body);
        prefs.setString('verifystatus', verifyApi.message);
        return success = true;
      } else {
        prefs.setString('verifystatus', 'Please enter the correct otp.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
