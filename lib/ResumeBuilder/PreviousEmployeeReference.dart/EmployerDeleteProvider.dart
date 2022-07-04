import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEmployerDeleteProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostDeleteResumeEmployerapi(
    id,
    header,
  ) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/emprefdelete/$id'),
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
