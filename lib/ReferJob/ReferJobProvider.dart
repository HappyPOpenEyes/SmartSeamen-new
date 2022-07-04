import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class PostReferJobProvider extends ChangeNotifier {
  bool success = false;

  List<String> vesselType = [],
      nationalityId = [],
      deckRanks = [],
      engineRanks = [],
      cookRanks = [];
  String tentativeJoiningDate = "",
      companyName = "",
      shipName = "",
      imoNumber = "",
      shipRegisteredFlag = "",
      joiningPort = "",
      contactNumber = "",
      whatsappNumber = "",
      email = "";
  late int referJobValue;
  Future<bool> callPostReferJobapi(header) async {
    success = false;

    var body = {
      "Tentative_Joining_date": tentativeJoiningDate,
      "company_name": companyName,
      "ship_name": shipName,
      "ship_imo_no": imoNumber,
      "ship_registerd_flag": shipRegisteredFlag,
      "joiningport": joiningPort,
      "refer_job": referJobValue,
      "refer_by_call": contactNumber,
      "refer_by_whatsup": whatsappNumber,
      "refer_by_email": email,
      "deck": deckRanks,
      "engine": engineRanks,
      "cook": cookRanks,
      "vessel_type": vesselType,
      "Preferrednationality": nationalityId
    };

    print(body);
    try {
      var response =
          await http.post(Uri.parse(apiurl + '/referjob/addreferjob'),
              body: json.encode(body),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": header
              },
              encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);


      if (response.statusCode == 200) {
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
