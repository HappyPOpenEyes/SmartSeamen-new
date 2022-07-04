import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEditSTCWRecordDeleteProvider extends ChangeNotifier {
  bool success = false, isMandatoryDelete = false;
  String error = "";
  Future<bool> callpostDeleteResumeSTCWRecordapi(
    id,
    header,
  ) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/stcwdelete/$id'),
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
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      error = err.toString();
      return success = false;
    }
  }
}
