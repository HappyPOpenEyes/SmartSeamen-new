import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'DashboardCountDataResponse.dart';

class GetDashboardCountDataProvider extends ChangeNotifier {
  bool success = false, publishStatus = false;
  String totalJobs = "",
      availableJobs = "",
      appliedJobs = "",
      shortListCount = "";
  bool isAvailable = false;
  Future<bool> callGetDashboardCountDataapi(header) async {
    totalJobs = "";
    availableJobs = "";
    appliedJobs = "";
    shortListCount = "";
    isAvailable = false;
    var response = await http.get(
      Uri.parse(apiurl + '/crew-dashboard/GetCardCount'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      },
    );

    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      DashboardCountDataResponse dashboardJobResponse =
          dashboardCountDataResponseFromJson(response.body);

      totalJobs = dashboardJobResponse.data.totaljobs.toString();
      appliedJobs = dashboardJobResponse.data.appliedjob.toString();
      shortListCount = dashboardJobResponse.data.shortlistcount.toString();
      availableJobs = dashboardJobResponse.data.availablejob.toString();
      if (dashboardJobResponse.data.publishstatus == 1)
        publishStatus = true;
      else
        publishStatus = false;
      if (dashboardJobResponse.data.onboardstatus == 1)
        isAvailable = true;
      else
        isAvailable = false;
      return success = true;
    } else if (response.statusCode == 422) {
      return success = false;
    } else {
      return success = false;
    }
    // } catch (err) {
    //   print(err.toString());
    //   return success = false;
    // }
  }
}
