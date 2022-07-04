import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartseaman/constants.dart';

class ResumeJobPreferencesUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "Something went wrong.";
  Future<bool> callpostResumeJobPreferencesapi(
      promotion,
      rankid,
      secondaryRankId,
      vesselid,
      tentativedate,
      countryid,
      indosno,
      countryname,
      userid,
      header) async {
    var body = {
      "looking_for_promotion": promotion,
      "rank_id": rankid,
      "sub_rank_id": secondaryRankId,
      "vessel_preference": vesselid,
      "tentative_date": tentativedate,
      "nationality": countryid,
      "id": userid,
      "other_nationality": countryname,
      "indos_no": indosno
    };
    try {
      var response = await http.post(Uri.parse(apiurl + '/resume/jobpref'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
          encoding: Encoding.getByName("utf-8"));

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
      print(err.toString());
      //error = err;
      return success = false;
    }
  }
}
