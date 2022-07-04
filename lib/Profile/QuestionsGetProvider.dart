import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'AccountSecurityQuestionsResponse.dart';

class GetQuestionsProvider extends ChangeNotifier {
  String? photo;
  String firstname = "",
      lastname = "",
      email = "",
      mobile = "",
      id = "",
      alternateemail = "",
      countryid = "",
      planName = "",
      planId = "",
      planAmount = "",
      planStartDate = "";
  DateTime? planEndDate;
  bool isGoogle = false,
      isLinkedin = false,
      isFacebook = false,
      isTwitter = false,
      isApple = false,
      hasQuestions = false;
  Future<String> callgetquestionsapi(header) async {
    try {
      var response = await http.get(
        Uri.parse('$apiurl/configration/getall'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        // prefs.setString('profilestatus', profileResponseApi.message);
        return response.body;
      } else if (response.statusCode == 422) {
        //prefs.setString('profilestatus', 'Invalid Credentials.');
        return response.body;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return response.body;
      }
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }

  Future<String> callgetAccountQuestionsApi(header) async {
    isGoogle = false;
    isLinkedin = false;
    isFacebook = false;
    isTwitter = false;
    hasQuestions = false;
    planName = "";
    planId = "";
    planAmount = "";
    planStartDate = "";
    try {
    var response = await http.get(
      Uri.parse('$apiurl/resume/account'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header,
      },
    );

    print(response.statusCode);
    print(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      AccountSecurityQuestionsResponse accountSecurityQuestionsResponse =
          accountSecurityQuestionsResponseFromJson(response.body);
      photo = accountSecurityQuestionsResponse.data.photo;
      countryid = accountSecurityQuestionsResponse.data.countryId.toString();
      firstname = accountSecurityQuestionsResponse.data.firstname;
      lastname = accountSecurityQuestionsResponse.data.lastname;
      email = accountSecurityQuestionsResponse.data.email;
      mobile = accountSecurityQuestionsResponse.data.mobile.toString();
      id = accountSecurityQuestionsResponse.data.id;
      if (accountSecurityQuestionsResponse.data.alternateEmail != null) {
        alternateemail = accountSecurityQuestionsResponse.data.alternateEmail!;
      }
      if (accountSecurityQuestionsResponse.data.getSocialgoogle.isNotEmpty) {
        isGoogle = true;
      }
      if (accountSecurityQuestionsResponse.data.getSocialfacebook.isNotEmpty) {
        isFacebook = true;
      }
      if (accountSecurityQuestionsResponse.data.getSociallinkdin.isNotEmpty) {
        isLinkedin = true;
      }
      if (accountSecurityQuestionsResponse.data.getSocialtwitter.isNotEmpty) {
        isTwitter = true;
      }
      if (accountSecurityQuestionsResponse.data.getSocialapple.isNotEmpty) {
          isApple = true;
        }
      if (accountSecurityQuestionsResponse.data.payment != null) {
        planAmount = accountSecurityQuestionsResponse.data.payment!.planAmount
            .toString();
        planId = accountSecurityQuestionsResponse.data.payment!.id;
        // ignore: unnecessary_null_comparison
        if (accountSecurityQuestionsResponse.data.payment!.planExpiryDates !=
            null) {
          planEndDate = DateTime.parse(
              accountSecurityQuestionsResponse.data.payment!.planExpiryDates!);
        }
        planStartDate =
            accountSecurityQuestionsResponse.data.payment!.planStartDate;
        planName = accountSecurityQuestionsResponse.data.payment!.planCrewId;
      }
      print('Plane name is$planName');
      print(planEndDate);
      notifyListeners();
      if (accountSecurityQuestionsResponse.data.getuser.isEmpty) {
        prefs.setBool('HasQuestions', false);
        String response = await callgetquestionsapi(header);
        return response;
      } else {
        hasQuestions = true;
        prefs.setBool('HasQuestions', true);
        return response.body;
      }
      // prefs.setString('profilestatus', profileResponseApi.message);
    } else if (response.statusCode == 422) {
      //prefs.setString('profilestatus', 'Invalid Credentials.');
      return response.body;
    } else {
      //prefs.setString('profilestatus', 'Something went wrong.');
      return response.body;
    }
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
  }
}
