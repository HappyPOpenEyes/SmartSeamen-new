import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'DashboardJobResponse.dart';

class GetDashboardDataProvider extends ChangeNotifier {
  bool success = false;
  List<String> companyName = [],
      companyId = [],
      rankName = [],
      vesselname = [],
      expirationDate = [];
  Future<bool> callGetDashboardDataapi(header) async {
    companyName = [];
    companyId = [];
    rankName = [];
    vesselname = [];
    expirationDate = [];
    var response = await http.get(
      Uri.parse(apiurl + '/crew-dashboard/GetRankwiseJobData'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      },
    );

    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      DashboardJobResponse dashboardJobResponse =
          dashboardJobResponseFromJson(response.body);
      for (int i = 0; i < dashboardJobResponse.data.length; i++) {
        companyName.add(dashboardJobResponse.data[i].companyName);
        rankName.add(dashboardJobResponse.data[i].rankName);
        expirationDate.add(dashboardJobResponse.data[i].expirationDate);
        vesselname.add(dashboardJobResponse.data[i].vessel);
        companyId.add(dashboardJobResponse.data[i].id);
      }
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
