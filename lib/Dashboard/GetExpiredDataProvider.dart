import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'DashboardExpiredDataResponse.dart';

class GetDashboardExpiredDataProvider extends ChangeNotifier {
  bool success = false;
  List<String> docType = [], docName = [], docNumber = [];
  List<DateTime> expirationDate = [];
  Future<bool> callGetDashboardExpiredDataapi(header) async {
    docType = [];
    docName = [];
    docNumber = [];
    expirationDate = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/crew-dashboard/ExpiredData'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        DashboardExpiredDataResponse dashboardJobResponse =
            dashboardExpiredDataResponseFromJson(response.body);
        for (int i = 0; i < dashboardJobResponse.data.length; i++) {
          docType.add(dashboardJobResponse.data[i].document.toString());
          docName.add(dashboardJobResponse.data[i].documentName ?? 'Doc');
          expirationDate.add(dashboardJobResponse.data[i].validTillDates);
          docNumber.add(dashboardJobResponse.data[i].certificateNo!);
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
