import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ProfilePictureProvider extends ChangeNotifier {
  bool success = false;
  String error = "";
  Future<bool> callProfilePictureapi(userid, imagepath, header) async {
    //try {
      String addimageUrl = apiurl + '/profileuploadcrew';
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..fields.addAll({"id": userid})
        ..headers.addAll({
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": header
        })
        ..files.add(await http.MultipartFile.fromPath('photo', imagepath));

      var response = await request.send();

      print('Response is');
      print(response.statusCode);
      print(response.reasonPhrase);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        return success = true;
      } else if (response.statusCode == 422) {
        return success = false;
      } else {
        return success = false;
      }
    // } catch (err) {
    //   print(err.toString());
    //   error = err.toString();
    //   return success = false;
    // }
  }
}
