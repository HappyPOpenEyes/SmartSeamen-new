import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:intl/intl.dart';

import 'ShowAllNotificationResponse.dart';

class ShowAllNotificationsProvider extends ChangeNotifier {
  bool success = false;
  List<String> notificationTitle = [],
      notificationId = [],
      notificationSubject = [],
      notificationDate = [];
  List<int> notificationStatus = [];
  int numberOfNotifications = 0;
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');

  removeData(index) {
    notificationDate.removeAt(index);
    notificationId.removeAt(index);
    notificationSubject.removeAt(index);
    notificationTitle.removeAt(index);
    numberOfNotifications--;
    notifyListeners();
  }

  Future<bool> callShowAllNotificationsapi(header) async {
    var body = {
      "limit": 12,
      "offset": 0,
      "searchData": {"status": "", "searchQuery": ""},
      "sortOrder": [
        {"field": "id", "dir": "desc"}
      ]
    };
    try {
      var response = await http.post(
          Uri.parse('$apiurl/crew-notification/userallnotification'),
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
        ShowAllNotificationsResponse _showNotifications =
            showAllNotificationsResponseFromJson(response.body);
        numberOfNotifications = _showNotifications.data.length;
        for (int i = 0; i < _showNotifications.data.length; i++) {
          notificationDate.add(_showNotifications.data[i].updatedAt);
          notificationId.add(_showNotifications.data[i].id);
          notificationSubject.add(_showNotifications.data[i].subject);
          notificationTitle.add(_showNotifications.data[i].documentType);
          notificationStatus
              .add(int.parse(_showNotifications.data[i].status.toString()));
        }
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
