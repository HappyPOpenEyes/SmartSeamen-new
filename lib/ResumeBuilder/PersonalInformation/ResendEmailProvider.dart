import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResendEmailOTPSendProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callResendEmailOtpSendapi(userid, header) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resendemailotp/$userid'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

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
      return success = false;
    }
  }
}
