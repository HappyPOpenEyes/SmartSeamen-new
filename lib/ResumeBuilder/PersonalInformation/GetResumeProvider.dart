import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'ResumeBuilderResponse.dart';

import 'package:intl/intl.dart';

class GetResumeProvider extends ChangeNotifier {
  List<String> vesselType = [];
  bool isComplete = false;
  int vesselcount = 0;
  String fname = "-",
      lname = "-",
      email = "-",
      phonenumber = "-",
      alternatecountryid = "",
      countryid = "",
      alternatephonenumber = "-",
      dob = "",
      lookingPromotion = "",
      rankId = "",
      rankName = "",
      secondaryRank = "",
      nationality = "",
      othernationality = "",
      vesselpreftext = "",
      address1 = "",
      address2 = "-",
      city = "",
      state = "",
      adressCountry = "",
      adressCountryId = "",
      landmark = "",
      pincode = "",
      comaddress1 = "",
      comaddress2 = "-",
      comcity = "",
      comstate = "",
      comadressCountry = "",
      comadressCountryId = "",
      comlandmark = "",
      compincode = "",
      indosno = "",
      nationalityid = "",
      tentativejoiningdate = "",
      isCommunication = "";
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  Future<bool> callgetResumeapi(header) async {
    isComplete = false;
    vesselType = [];
    vesselcount = 0;
    fname = "-";
    lname = "-";
    email = "-";
    phonenumber = "-";
    alternatecountryid = "";
    countryid = "";
    alternatephonenumber = "-";
    dob = "";
    lookingPromotion = "";
    rankName = "";
    rankId = "";
    secondaryRank = "";
    nationality = "";
    othernationality = "";
    vesselpreftext = "";
    address1 = "";
    address2 = "-";
    city = "";
    state = "";
    adressCountry = "";
    adressCountryId = "";
    landmark = "";
    pincode = "";
    comaddress1 = "";
    comaddress2 = "-";
    comcity = "";
    comstate = "";
    comadressCountry = "";
    comadressCountryId = "";
    comlandmark = "";
    compincode = "";
    indosno = "";
    nationalityid = "";
    tentativejoiningdate = "";
    isCommunication = "";
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getbyid'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        ResumeBuilderData resumeResponseApi =
            resumeBuilderDataFromJson(response.body);
        fname = resumeResponseApi.data.firstname;
        lname = resumeResponseApi.data.lastname;
        email = resumeResponseApi.data.email;
        phonenumber = resumeResponseApi.data.mobile.toString();
        alternatecountryid =
            resumeResponseApi.data.alternateCountryId.toString();
        countryid = resumeResponseApi.data.countryId.toString();
        alternatephonenumber =
            resumeResponseApi.data.alternateMobileNo.toString();
        resumeResponseApi.data.dob == null
            ? dob = ""
            : dob = formatter.format(resumeResponseApi.data.dob!);
        if (resumeResponseApi.data.getuseraddress != null) {
          if (resumeResponseApi.data.getuseraddress!.address1 != null) {
            address1 = resumeResponseApi.data.getuseraddress!.address1;
            if (resumeResponseApi.data.getuseraddress!.address2 != null) {
              address2 = resumeResponseApi.data.getuseraddress!.address2;
            } else {
              address2 = "";
            }
            city = resumeResponseApi.data.getuseraddress!.city;
            adressCountry = resumeResponseApi.data.getuseraddress!.countryName;
            adressCountryId =
                resumeResponseApi.data.getuseraddress!.countryId.toString();
            landmark = resumeResponseApi.data.getuseraddress!.landmark;
            pincode = resumeResponseApi.data.getuseraddress!.pincode.toString();
            state = resumeResponseApi.data.getuseraddress!.state;
            isCommunication = resumeResponseApi
                .data.getuseraddress!.isCommunicationAddress
                .toString();
            comaddress1 =
                resumeResponseApi.data.getuseraddress!.comAddress1 ?? "";
            if (resumeResponseApi.data.getuseraddress!.comAddress2 != null) {
              comaddress2 = resumeResponseApi.data.getuseraddress!.comAddress2;
            } else {
              comaddress2 = "";
            }
            comcity = resumeResponseApi.data.getuseraddress!.comCity ?? "";
            comadressCountry =
                resumeResponseApi.data.getuseraddress!.comCountryName ?? "";
            if (resumeResponseApi.data.getuseraddress!.comCountryId != null) {
              comadressCountryId = resumeResponseApi
                  .data.getuseraddress!.comCountryId
                  .toString();
            } else {
              comadressCountryId = "";
            }

            comlandmark =
                resumeResponseApi.data.getuseraddress!.comLandmark ?? "";
            if (resumeResponseApi.data.getuseraddress!.comPincode != null) {
              compincode =
                  resumeResponseApi.data.getuseraddress!.comPincode.toString();
            } else {
              compincode = "";
            }
            comstate = resumeResponseApi.data.getuseraddress!.comState ?? "";
          } else {
            isCommunication = resumeResponseApi
                .data.getuseraddress!.isCommunicationAddress
                .toString();
          }
        } else {
          isCommunication = "0";
        }
        if (resumeResponseApi.data.resume != null) {
          if (int.parse(
                  resumeResponseApi.data.resume!.publishStatus.toString()) ==
              0) {
            prefs.setBool('isResumePublished', false);
          } else {
            prefs.setBool('isResumePublished', true);
          }
          rankName = resumeResponseApi.data.resume!.getrankName;
          secondaryRank = resumeResponseApi.data.resume!.subgetrankName ?? '';
          rankId = resumeResponseApi.data.resume!.rankId;
          vesselType = resumeResponseApi.data.resume!.vesselPreference;
          for (int i = 0; i < vesselType.length; i++) {
            vesselcount = vesselType.length;
          }
          vesselpreftext = resumeResponseApi.data.resume!.vesselName;
          if (resumeResponseApi.data.resume!.indosNo != null) {
            indosno = resumeResponseApi.data.resume!.indosNo!;
          } else {
            indosno = "";
          }
          tentativejoiningdate =
              formatter.format(resumeResponseApi.data.resume!.tentativeDate);
          nationality = resumeResponseApi.data.resume!.nationalityName;
          nationalityid = resumeResponseApi.data.resume!.nationality;
          othernationality =
              resumeResponseApi.data.resume!.otherNationality ?? "";

          lookingPromotion =
              resumeResponseApi.data.resume!.lookingForPromotion.toString();
        }
        if (fname.isNotEmpty &&
            rankName.isNotEmpty &&
            address1.isNotEmpty &&
            isCommunication != null) {
          prefs.setBool('PersonalTab', true);
        } else {
          prefs.setBool('PersonalTab', false);
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

  increaselength() {
    vesselcount++;
    notifyListeners();
  }

  decreaselength() {
    vesselcount--;
    notifyListeners();
  }
}
