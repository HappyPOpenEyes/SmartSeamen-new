import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeAddressUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostResumeAddressapi(adress1, landmark, countryid, pincode,
      city, state, isCommunication, header,
      {String address2 = "",
      String comAdress1 = "",
      String comAdress2 = "",
      String comLandmark = "",
      String comCountryid = "",
      String comPincode = "",
      String comCity = "",
      String comState = ""}) async {
    var body = {
      "address1": adress1,
      "address2": address2,
      "landmark": landmark,
      "country_id": countryid,
      "pincode": pincode,
      "city": city,
      "state": state,
      "is_communication_address": isCommunication,
      "com_address1": comAdress1,
      "com_address2": comAdress2,
      "com_landmark": comLandmark,
      "com_country_id": comCountryid,
      "com_pincode": comPincode,
      "com_city": comCity,
      "com_state": comState,
    };
    try {
      var response = await http.post(Uri.parse('$apiurl/resume/useraddress'),
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
      error = err.toString();
      return success = false;
    }
  }
}
