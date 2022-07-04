import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import 'SecondaryRankResponse.dart';

class SecondaryRankProvider extends ChangeNotifier {
  bool success = false;
  List<String> secondaryrankname = [],
      secondaryrankid = [],
      secondaryranktype = [];
  Future<bool> callSecondaryRankapi(id, header) async {
    secondaryrankname = [];
    secondaryrankid = [];
    secondaryranktype = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getsecondaryrank/$id'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header
        },
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        GetsecondaryrankResponse getsecondaryrankResponse =
            getsecondaryrankResponseFromJson(response.body);

        for (int i = 0; i < getsecondaryrankResponse.data.length; i++) {
          if (!secondaryrankid.contains(getsecondaryrankResponse.data[i].id)) {
            secondaryrankname.add(getsecondaryrankResponse.data[i].rankName);
            secondaryrankid.add(getsecondaryrankResponse.data[i].id);
            secondaryranktype
                .add(getsecondaryrankResponse.data[i].rankType.toString());
          }
        }
        notifyListeners();

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
