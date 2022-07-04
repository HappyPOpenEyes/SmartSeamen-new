import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEditSTCWDocUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostResumeSTCWDocapi(
    postMandatorySTCWData,
    postOptionalStcwData,
    header,
  ) async {
    var body = {
      "stcwDocuments": postMandatorySTCWData,
      "stcwoptional": postOptionalStcwData
    };

    try {
      var response = await http.post(Uri.parse('$apiurl/resume/medicaldoc'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
          encoding: Encoding.getByName("utf-8"));

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
