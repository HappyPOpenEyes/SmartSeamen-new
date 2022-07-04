import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ClearNotificationsProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callClearNotificationsapi(header) async {
    try {
      var response = await http.get(
          Uri.parse(apiurl + '/crew-notification/clearnotification/0'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header
          });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        notifyListeners();
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
      return success = false;
    }
  }
}
