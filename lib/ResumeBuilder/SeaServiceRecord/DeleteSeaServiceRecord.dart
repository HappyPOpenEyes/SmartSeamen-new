import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEditSeaServiceDeleteProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostDeleteResumeSeaServiceapi(
    id,
    header,
  ) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/seaservicedelete/$id'),
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
      error = err.toString();
      return success = false;
    }
  }
}
