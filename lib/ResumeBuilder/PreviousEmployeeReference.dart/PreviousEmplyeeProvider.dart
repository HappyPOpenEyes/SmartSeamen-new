import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'PreviousEmployerResponse.dart';

class ResumeEmployerProvider extends ChangeNotifier {
  bool success = false, isComplete = false;
  String error = "";
  int length = 1;
  List<String> companyName = [],
      employerId = [],
      contactPersonName = [],
      contactNumber = [],
      countryid = [];

  increaselength() {
    length++;
    notifyListeners();
  }

  decreaselength() {
    length--;
    notifyListeners();
  }

  Future<bool> callgetSeaServiceapi(header) async {
    length = 1;
    isComplete = false;
    employerId = [];
    companyName = [];
    contactPersonName = [];
    contactNumber = [];
    countryid = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getbyempref'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        GetEmployerResponse getEmployerResponse =
            getEmployerResponseFromJson(response.body);
        if (getEmployerResponse.data.getempref.isNotEmpty) {
          prefs.setBool('EmployerTab', true);

          length = getEmployerResponse.data.getempref.length;
          for (int i = 0; i < getEmployerResponse.data.getempref.length; i++) {
            isComplete = true;
            companyName.add(getEmployerResponse.data.getempref[i].companyName);
            contactNumber.add(
                getEmployerResponse.data.getempref[i].contactno.toString());
            contactPersonName
                .add(getEmployerResponse.data.getempref[i].contactPerson);
            employerId.add(getEmployerResponse.data.getempref[i].id);
            countryid.add(
                getEmployerResponse.data.getempref[i].countryId.toString());
          }
        } else {
          prefs.setBool('EmployerTab', false);
        }
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
