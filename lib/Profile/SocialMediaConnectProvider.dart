import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class SocialMediaConnectProvider extends ChangeNotifier {
  Future<String> callSocialMediaProviderapi(
      providername, providerid, header) async {
    var body = {"provider_name": providername, "provider_id": providerid};
    print(body);
    try {
      var response = await http.post(Uri.parse(apiurl + '/connect'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header,
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        // SocialMediaProviderResponse profileResponseApi = SocialMediaProviderResponseFromJson(response.body);
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
}
