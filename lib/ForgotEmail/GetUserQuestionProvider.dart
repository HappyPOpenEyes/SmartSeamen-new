
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'UserQuestionResponse.dart';

class UserQuestionProvider extends ChangeNotifier {
  bool success = false;
  late String userid;
  List<String> questionscode = [];
  List<String> questionsname = [];
  bool showIssue = false;
  dynamic statusCode;
  Future<bool> callUserQuestionapi(id) async {
    questionscode = [];
    questionsname = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/userquestion/$id'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print(response.statusCode);
      print(response.body);

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        UserQuestionResponse getSecurityQuestionResponse =
            userQuestionResponseFromJson(response.body);
        if (getSecurityQuestionResponse.data.isEmpty) {
          showIssue = false;
        } else {
          showIssue = true;
          for (int i = 0; i < getSecurityQuestionResponse.data.length; i++) {
            questionsname.add(getSecurityQuestionResponse.data[i].displayText);
            questionscode
                .add(getSecurityQuestionResponse.data[i].id.toString());
          }
        }
        return success = true;
      } else if (response.statusCode == 422) {
        //prefs.setString('profilestatus', 'Invalid Credentials.');
        return success = false;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
