import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ResumePublishStatusProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callPublishStatusPostapi(
    publishstatus,
    header,
  ) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/resumepublish/$publishstatus'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        return success = true;
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
