import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'SocialLoginCheckResponse.dart';

class SocialMediaCheckProvider extends ChangeNotifier {
  var header;
  Future<bool> callSocialMediaProviderapi(providerid) async {
    var body = {"provider_id": providerid};
    print(body);
    try {
      var response = await http.post(Uri.parse(apiurl + '/logincheck'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        SocialLoginCheckResponse socialLoginCheckResponse =
            socialLoginCheckResponseFromJson(response.body);
        header = 'Bearer ' + socialLoginCheckResponse.data.accessToken;
        // SocialMediaProviderResponse profileResponseApi = SocialMediaProviderResponseFromJson(response.body);
        // prefs.setString('profilestatus', profileResponseApi.message);

        return true;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return false;
      }
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
}
