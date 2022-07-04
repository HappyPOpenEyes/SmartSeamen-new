import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'ApplyRankResponse.dart';

class GetApplyRankProvider extends ChangeNotifier {
  bool success = false;
  List<String> rankName = [], rankId = [];
  Future<bool> callGetApplyRankapi(jobId, header) async {
    success = false;
    rankName = [];
    rankId = [];
    try {
      var response = await http.get(
        Uri.parse(apiurl + '/resume/getrankdetail/' + jobId),
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
        ApplyRankResponse _applyRankResponse =
            applyRankResponseFromJson(response.body);
        for (int i = 0; i < _applyRankResponse.data.length; i++) {
          rankName.add(_applyRankResponse.data[i].rankName);
          rankId.add(_applyRankResponse.data[i].rankId);
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
