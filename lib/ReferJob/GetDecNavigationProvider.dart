import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartseaman/ReferJob/DeckNavigationResponse.dart';

import '../constants.dart';

class GetDeckNavigationProvider extends ChangeNotifier {
  List<String> deckNavigationName = [], deckNavigationId = [];
  Future<bool> callgetDeckNavigationapi(header) async {
    deckNavigationName = [];
    deckNavigationId = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/publishjob/getdecknavi'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        DeckNavigationResponse deckNavigationResponse =
            deckNavigationResponseFromJson(response.body);
        for (int i = 0; i < deckNavigationResponse.data.length; i++) {
          deckNavigationName.add(deckNavigationResponse.data[i].rankName);
          deckNavigationId.add(deckNavigationResponse.data[i].id);
        }
        notifyListeners();
        return true;
      } else if (response.statusCode == 422) {
        //prefs.setString('Resumestatus', 'Invalid Credentials.');
        return false;
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
