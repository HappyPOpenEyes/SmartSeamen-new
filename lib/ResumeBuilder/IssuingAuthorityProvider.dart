import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartseaman/constants.dart';

import 'IssuingAuthorityResponse.dart';

class ResumeIssuingAuthorityProvider extends ChangeNotifier {
  bool success = false;
  String error = "Something went wrong.";
  List<String> countrycode = [];
  List<String> countryname = [];
  Future<bool> callgetResumeIssuingAuthorityapi(header) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getissuing'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      
      if (response.statusCode == 200) {
        IssuingAuthorityResponse getIssuingAuthority =
            issuingAuthorityResponseFromJson(response.body);
        for (int i = 0; i < getIssuingAuthority.data.length; i++) {
          countryname.add(getIssuingAuthority.data[i].issueName);
          countrycode.add(getIssuingAuthority.data[i].id.toString());
        }
        return success = true;
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
