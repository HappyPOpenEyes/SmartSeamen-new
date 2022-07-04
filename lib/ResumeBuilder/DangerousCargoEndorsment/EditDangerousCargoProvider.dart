import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
class ResumeEditDangerousCargoUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostResumeAddressapi(
    postdata,
    header,
  ) async {
    var body = {"endorsements": postdata};
    try {
      var response = await http.post(Uri.parse('$apiurl/resume/dangerous'),
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
