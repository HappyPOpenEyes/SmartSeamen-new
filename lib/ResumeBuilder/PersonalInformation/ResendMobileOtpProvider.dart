import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResendMobileOTPSendProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callResendMobileOtpSendapi(userid, header) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resendmobile/$userid'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        return success = true;
      } else if (response.statusCode == 422) {
        return success = false;
      } else {
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
