import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'EngineRankResponse.dart';

class GetEngineRankProvider extends ChangeNotifier {
  List<String> engineRankName = [],
      engineRankId = [],
      cookRankName = [],
      cookRankId = [];
  Future<bool> callgetEngingeRankapi(header) async {
    engineRankName = [];
    engineRankId = [];
    cookRankName = [];
    cookRankId = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/publishjob/getrankengine'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        EngineRankResponse engineResponse =
            engineRankResponseFromJson(response.body);
        for (int i = 0; i < engineResponse.data.engine.length; i++) {
          engineRankName.add(engineResponse.data.engine[i].rankName);
          engineRankId.add(engineResponse.data.engine[i].id);
        }
        if (engineResponse.data.cook != null) {
          for (int i = 0; i < engineResponse.data.cook!.length; i++) {
            cookRankName.add(engineResponse.data.cook![i].rankName);
            cookRankId.add(engineResponse.data.cook![i].id);
          }
        }
        notifyListeners();
        return true;
      } else {
        //prefs.setString('Resumestatus', 'Something went wrong.');
        return false;
      }
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
}
