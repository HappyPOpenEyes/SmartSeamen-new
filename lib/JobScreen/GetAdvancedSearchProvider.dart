import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'AdvancedSearchResponse.dart';

class GetAdvancedSearchProvider extends ChangeNotifier {
  bool success = false;
  List<String> companyName = [],
      companyId = [],
      rankName = [],
      rankId = [],
      vesselName = [],
      vesselId = [],
      nationalityName = [],
      nationalityId = [];
  Future<bool> callGetAdvancedSearchapi(header) async {
    success = false;
    companyName = [];
    companyId = [];
    rankName = [];
    rankId = [];
    vesselName = [];
    vesselId = [];
    nationalityName = [];
    nationalityId = [];
    try {
      var response = await http.get(
        Uri.parse(apiurl + '/resume/getallsearchdetail'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.statusCode);
      //print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        AdvancedSearchResponse advancedSearchResponse =
            advancedSearchResponseFromJson(response.body);
        for (int i = 0; i < advancedSearchResponse.data.company.length; i++) {
          companyName.add(advancedSearchResponse.data.company[i].companyName);
          companyId.add(advancedSearchResponse.data.company[i].companyId);
        }
        for (int i = 0; i < advancedSearchResponse.data.rank.length; i++) {
          rankName.add(advancedSearchResponse.data.rank[i].rankName);
          rankId.add(advancedSearchResponse.data.rank[i].rankId);
        }
        for (int i = 0; i < advancedSearchResponse.data.vessel.length; i++) {
          vesselName.add(advancedSearchResponse.data.vessel[i].vesselName);
          vesselId.add(advancedSearchResponse.data.vessel[i].id);
        }
        for (int i = 0;
            i < advancedSearchResponse.data.nationality.length;
            i++) {
          nationalityName
              .add(advancedSearchResponse.data.nationality[i].nationalityName);
          nationalityId.add(advancedSearchResponse.data.nationality[i].id);
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
