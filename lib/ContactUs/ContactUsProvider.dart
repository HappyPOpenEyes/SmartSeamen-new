import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ContactUsProvider extends ChangeNotifier {
  bool success = false, checkJobPref = false;
  Future<bool> callContactUsapi(type, message, subject, header) async {
    checkJobPref = false;
    var body = {"Type": type, "message": message, "subject": subject};
    try {
      var response = await http.post(Uri.parse(apiurl + '/contactform'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return success = true;
      } else if (response.statusCode == 500) {
        checkJobPref = true;
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
