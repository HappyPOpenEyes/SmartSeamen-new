import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEditCompetencyRecordDeleteProvider extends ChangeNotifier {
  bool success = false, isMandatoryDelete = false;
  String error = "";
  Future<bool> callpostDeleteResumeCompetencyRecordapi(
    id,
    header,
  ) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/competancydelete/$id'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
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
      error = err.toString();
      return success = false;
    }
  }
}
