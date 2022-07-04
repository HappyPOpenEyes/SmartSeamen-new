import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'ValidTillResponse.dart';

class GetValidTypeProvider extends ChangeNotifier {
  bool success = false;
  List<String> displayText = [], validTypeId = [], validTypeValue = [];
  Future<bool> callgetValidTypeapi(header) async {
    if (displayText.isEmpty) {
      try {
        var response = await http.get(
          Uri.parse('$apiurl/resume/getvalidtype'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
        );

        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          ValidTillDate validResponse = validTillDateFromJson(response.body);
          for (int i = 0; i < validResponse.data.length; i++) {
            displayText.add(validResponse.data[i].displayText);
            validTypeValue.add(validResponse.data[i].value);
            validTypeId.add(validResponse.data[i].id.toString());
          }
          return success = true;
        } else {
          //prefs.setString('profilestatus', 'Something went wrong.');
          return success = false;
        }
      } catch (err) {
        print(err.toString());
        //error = err;
        return success = false;
      }
    } else {
      return true;
    }
  }
}
