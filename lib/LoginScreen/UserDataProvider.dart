import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'UserLimitResponse.dart';

class UserDataProvider extends ChangeNotifier {
  bool success = false;
  String firstname = "", lastname = "", email = "", mobile = "", id = "";
  bool canCreateProfile = false,
      canDownloadResume = false,
      canJobNotify = false,
      canEmailSupport = false,
      canProfileViewNotify = false,
      canProfileHighlight = false,
      jobViews = true,
      hasRecoveryQuestions = false;
  int jobAppPerDay = 0;
  Future<bool> callUserDataapi(header) async {
    canCreateProfile = false;
    canDownloadResume = false;
    canJobNotify = false;
    canEmailSupport = false;
    canProfileViewNotify = false;
    canProfileHighlight = false;
    jobAppPerDay = 0;
    jobViews = true;
    hasRecoveryQuestions = false;
    try {
      var response =
          await http.get(Uri.parse('$apiurl/getmobilecrewdata'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      });

      print(response.statusCode);
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        UserLimitResponse userLimitResponse =
            userLimitResponseFromJson(response.body);
        Payment? limit = userLimitResponse.data.payment;
        firstname = userLimitResponse.data.user[0].firstname;
        lastname = userLimitResponse.data.user[0].lastname;
        mobile = userLimitResponse.data.user[0].mobile.toString();
        email = userLimitResponse.data.user[0].email;
        id = userLimitResponse.data.user[0].id;
        if (userLimitResponse.data.isUserRecoveryQuestion == 1) {
          hasRecoveryQuestions = true;
          prefs.setBool('RecoveryQuestions', true);
        } else {
          prefs.setBool('RecoveryQuestions', false);
          hasRecoveryQuestions = false;
        }
        if (limit != null) {
          print('Getting inside null');
          if (int.parse(limit.createProfile.toString()) == 0) {
            canCreateProfile = false;
          } else {
            canCreateProfile = true;
          }
          if (int.parse(limit.downloadResume.toString()) == 0) {
            canDownloadResume = false;
          } else {
            canDownloadResume = true;
          }
          if (int.parse(limit.jobNotification.toString()) == 0) {
            canJobNotify = false;
          } else {
            canJobNotify = true;
          }
          if (int.parse(limit.emailSupport.toString()) == 0) {
            canEmailSupport = false;
          } else {
            canEmailSupport = true;
          }
          if (int.parse(limit.profileViewNotification.toString()) == 0) {
            canProfileViewNotify = false;
          } else {
            canProfileViewNotify = true;
          }
          if (int.parse(limit.profileHighlightEmployer.toString()) == 0) {
            canProfileHighlight = false;
          } else {
            canProfileHighlight = true;
          }
          if (int.parse(limit.jobsViews.toString()) == 0) {
            jobViews = false;
          } else {
            jobViews = true;
          }
          jobAppPerDay = limit.jobApplicationPerDay;
        } else {
          print('not Getting inside null');
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
