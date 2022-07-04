import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'BellNotificationResponse.dart';

class NotificationsProvider extends ChangeNotifier {
  bool success = false;
  List<String> notificationTitle = [],
      notificationId = [],
      notificationSubject = [],
      notificationDate = [];
  int numberOfNotifications = 0;
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');

  removeData(index) async {
    notificationDate.removeAt(index);
    notificationId.removeAt(index);
    notificationSubject.removeAt(index);
    notificationTitle.removeAt(index);
    numberOfNotifications--;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('NotificationLength', numberOfNotifications);
    prefs.setStringList('NotificationTitle', notificationTitle);
    prefs.setStringList('NotificationSubject', notificationTitle);
    notifyListeners();
  }

  Future<bool> callNotificationsapi(header) async {
    notificationTitle = [];
    notificationSubject = [];
    notificationId = [];
    numberOfNotifications = 0;
    try {
      var response = await http.get(
          Uri.parse(apiurl + '/crew-notification/bellnotification'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header
          });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        BellNotificationsApi bellNotificationsApi =
            bellNotificationsApiFromJson(response.body);
        for (int i = 0; i < bellNotificationsApi.data.length; i++) {
          notificationId.add(bellNotificationsApi.data[i].id);
          notificationTitle.add(bellNotificationsApi.data[i].documentType);
          notificationSubject.add(bellNotificationsApi.data[i].subject);
          notificationDate
              .add(formatter.format(bellNotificationsApi.data[i].updatedAt));
        }
        numberOfNotifications = notificationTitle.length;
        // GetProfileResponse profileResponseApi = getProfileResponseFromJson(response.body);
        // prefs.setString('profilestatus', profileResponseApi.message);
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
