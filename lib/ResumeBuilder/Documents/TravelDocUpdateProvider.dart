import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ResumeEditTravelDocUpdateProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callpostResumeTravelDocapi(
    passportId,
    passportnumber,
    placeofissue,
    issuedate,
    expirydate,
    validTillType,
    configurationId,
    postVisaData,
    postCDCData,
    header,
  ) async {
    var body = {
      "passportDetails": [
        {
          "id": passportId,
          "issue_date": issuedate,
          "valid_till_date": expirydate,
          "valid_till_type": validTillType,
          "document_type": "1",
          "document_no": passportnumber,
          "place_of_issue": placeofissue,
          "configration_id": configurationId
        }
      ],
      "visaDetails": postVisaData,
      "cdcDetails": postCDCData
    };
    print(body);
    try {
      var response = await http.post(Uri.parse('$apiurl/resume/travel'),
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
