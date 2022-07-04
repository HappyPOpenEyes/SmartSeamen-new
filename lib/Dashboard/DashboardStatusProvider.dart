import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class DashboardStatusProvider extends ChangeNotifier {
  bool success = false, checkJobPref = false;
  Future<bool> callPostDashboardStatusapi(status, header) async {
    checkJobPref = false;
    var response = await http.get(
      Uri.parse('$apiurl/crew-dashboard/OnboardStatus/$status'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return success = true;
    } else if (response.statusCode == 404) {
      checkJobPref = true;
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
