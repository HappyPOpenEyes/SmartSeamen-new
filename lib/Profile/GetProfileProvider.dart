import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class GetProfileProvider extends ChangeNotifier {
  Future<String> callgetprofileapi(header) async {
    try {
      var response = await http.get(
        Uri.parse(apiurl + '/userdata'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        // GetProfileResponse profileResponseApi = getProfileResponseFromJson(response.body);
        // prefs.setString('profilestatus', profileResponseApi.message);
        return response.body;
      } else if (response.statusCode == 422) {
        //prefs.setString('profilestatus', 'Invalid Credentials.');
        return response.body;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return response.body;
      }
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }
}
