import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ResendOTPSendProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callResendOtpSendapi(userid) async {
    try {
      var response = await http.get(
        Uri.parse(apiurl + '/resendemail/' + userid),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        return success = true;
      } else {
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
