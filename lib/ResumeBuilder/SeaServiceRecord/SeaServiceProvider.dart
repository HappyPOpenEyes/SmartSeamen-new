import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'GetSeaServiceResponse.dart';

class ResumeSeaServiceProvider extends ChangeNotifier {
  bool success = false, isComplete = false;
  String error = "";
  int length = 1;

  List<String> vessel_name = [],
      companyName = [],
      ranktype = [],
      imo_number = [],
      vesselId = [],
      engine_name = [],
      rank_name = [],
      vessel_typeid = [],
      vesselTypeName = [],
      engine_typeid = [],
      rank_typeid = [],
      gross_tonnage = [],
      issuingAuthorityName = [],
      signondate = [],
      signoffdate = [],
      durationRankName = [],
      duration = [];
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');

  increaselength() {
    length++;
    notifyListeners();
  }

  decreaselength() {
    length--;
    notifyListeners();
  }

  Future<bool> callgetSeaServiceapi(header, userid) async {
    length = 1;
    isComplete = false;
    vessel_name = [];
    companyName = [];
    imo_number = [];
    engine_name = [];
    rank_name = [];
    ranktype = [];
    vesselId = [];
    vessel_typeid = [];
    engine_typeid = [];
    rank_typeid = [];
    gross_tonnage = [];
    issuingAuthorityName = [];
    signondate = [];
    signoffdate = [];
    durationRankName = [];
    duration = [];
    print(userid);
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getbyseaservice/$userid'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        GetSearServiceResponse getSeaServiceResponse =
            getSearServiceResponseFromJson(response.body);
        if (getSeaServiceResponse.data.getseaservice.isNotEmpty) {
          length = getSeaServiceResponse.data.getseaservice.length;
          prefs.setBool('SeaServiceTab', true);
        } else {
          prefs.setBool('SeaServiceTab', false);
        }
        for (int i = 0;
            i < getSeaServiceResponse.data.getseaservice.length;
            i++) {
          ranktype.add(
              getSeaServiceResponse.data.getseaservice[i].rankType.toString());
          isComplete = true;
          vesselId.add(getSeaServiceResponse.data.getseaservice[i].id);
          vessel_typeid
              .add(getSeaServiceResponse.data.getseaservice[i].vesselType);
          companyName
              .add(getSeaServiceResponse.data.getseaservice[i].companyName);
          vessel_name
              .add(getSeaServiceResponse.data.getseaservice[i].vesselName);
          vesselTypeName
              .add(getSeaServiceResponse.data.getseaservice[i].vessel);
          rank_typeid.add(getSeaServiceResponse.data.getseaservice[i].rankId);
          rank_name.add(getSeaServiceResponse.data.getseaservice[i].rankName);
          if (getSeaServiceResponse.data.getseaservice[i].engineId != null) {
            engine_typeid
                .add(getSeaServiceResponse.data.getseaservice[i].engineId!);
          } else {
            engine_typeid.add("");
          }
          engine_name.add(
              getSeaServiceResponse.data.getseaservice[i].engineName ?? '');
          signoffdate.add(formatter
              .format(getSeaServiceResponse.data.getseaservice[i].signOff));
          signondate.add(formatter
              .format(getSeaServiceResponse.data.getseaservice[i].signOn));
          gross_tonnage
              .add(getSeaServiceResponse.data.getseaservice[i].grossTonnage);
          imo_number.add(getSeaServiceResponse.data.getseaservice[i].imonumber);
        }
        for (int i = 0; i < getSeaServiceResponse.data.summary.length; i++) {
          durationRankName.add(getSeaServiceResponse.data.summary[i].rankName);
          duration.add(getSeaServiceResponse.data.summary[i].totalDuration);
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
      //error = err;
      return success = false;
    }
  }
}
