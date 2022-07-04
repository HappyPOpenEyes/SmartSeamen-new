import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'DashboardNotificationResponse.dart';

class GetDashboardNotificationProvider extends ChangeNotifier {
  bool success = false;
  List<String> notificationCompanyName = [],
      notificationSubject = [],
      notificationDate = [];
  Future<bool> callGetDashboardNotificationapi(header) async {
    notificationCompanyName = [];
    notificationSubject = [];
    notificationDate = [];
    try {
      var response = await http.get(
        Uri.parse(apiurl + '/crew-dashboard/GetNotificationData'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        DashboardNotificationResponse dashboardNotificationResponse =
            dashboardNotificationResponseFromJson(response.body);

        for (int i = 0; i < dashboardNotificationResponse.data.length; i++) {
          notificationCompanyName
              .add(dashboardNotificationResponse.data[i].companyname);
          notificationSubject
              .add(dashboardNotificationResponse.data[i].subject);
          notificationDate.add(dashboardNotificationResponse.data[i].updatedAt);
        }
        return success = true;
      } else if (response.statusCode == 422) {
        return success = false;
      } else {
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
