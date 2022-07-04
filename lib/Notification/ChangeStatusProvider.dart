import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ChangeStatusNotificationsProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callChangeStatusNotificationsapi(id, status, header) async {
    print(apiurl +
        '/crew-notification/readunreadNotification/' +
        id +
        '/' +
        status);
    try {
      var response = await http.get(
          Uri.parse(apiurl +
              '/crew-notification/readunreadNotification/' +
              id +
              '/' +
              status),
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