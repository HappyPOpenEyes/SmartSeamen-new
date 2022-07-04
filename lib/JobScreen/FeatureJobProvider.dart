import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'FeatureJobResponse.dart';

class FeatureJobListProvider extends ChangeNotifier {
  bool success = false, hasbeenCalled = false;
  List<String> companyId = [],
      companyLogo = [],
      companyName = [],
      searchList = [],
      jobExpirationDate = [],
      vesselType = [],
      rankList = [];
  List<bool> isApplied = [], isReferJob = [];

  clearData() {
    success = false;
    companyId = [];
    companyLogo = [];
    companyName = [];
    searchList = [];
    jobExpirationDate = [];
    vesselType = [];
    rankList = [];
    isApplied = [];
    isReferJob = [];
  }

  Future<bool> callGetJobListapi(
      header,
      field,
      sortOrder,
      filterCompanyId,
      rankId,
      vesselId,
      nationalityId,
      tentativeJoingDate,
      tentativeEndDate,
      expirationStartDate,
      expirationEndDate) async {
    hasbeenCalled = false;
    success = false;
    companyId = [];
    companyLogo = [];
    companyName = [];
    searchList = [];
    jobExpirationDate = [];
    vesselType = [];
    rankList = [];
    isApplied = [];
    isReferJob = [];
    var body = {
      "limit": 2,
      "offset": "",
      "searchData": {"status": "", "searchQuery": ""},
      "sortOrder": [
        {"field": field, "dir": sortOrder}
      ],
      "rank_id": rankId,
      "vessel_type": vesselId,
      "company_id": filterCompanyId,
      "nationality": nationalityId,
      "fromDate": tentativeJoingDate,
      "toDate": tentativeEndDate,
      "jobfromDate": expirationStartDate,
      "jobtoDate": expirationEndDate
    };

    print(body);
    try {
      var response = await http.post(Uri.parse('$apiurl/resume/getfeaturedjob'),
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
        FeatureJobResponse allJobResponse =
            featureJobResponseFromJson(response.body);

        int featureLength = 0;
        if (allJobResponse.data != null) {
          if (allJobResponse.data!.featured.length > 2) {
            featureLength = 2;
          } else {
            featureLength = allJobResponse.data!.featured.length;
          }
          for (int i = 0; i < featureLength; i++) {
            if (allJobResponse.data!.featured[i].referJobStatus == 1) {
              isReferJob.add(true);
            } else {
              isReferJob.add(false);
            }
            companyId.add(allJobResponse.data!.featured[i].companyId);
            if (allJobResponse.data!.featured[i].companyLogo != null) {
              companyLogo.add(allJobResponse.data!.featured[i].companyLogo!);
            } else {
              companyLogo.add("");
            }

            companyName.add(allJobResponse.data!.featured[i].companyName);
            jobExpirationDate
                .add(allJobResponse.data!.featured[i].jobExpirationDate);
            if (allJobResponse.data!.featured[i].apply == 1) {
              isApplied.add(true);
            } else {
              isApplied.add(false);
            }
            vesselType.add(allJobResponse.data!.featured[i].vesselName);
            rankList.add(allJobResponse.data!.featured[i].getrankdetail);
          }

          for (int i = 0; i < companyName.length; i++) {
            searchList.add(companyName[i]);
          }
          for (int i = 0; i < rankList.length; i++) {
            searchList.add(rankList[i]);
          }
          for (int i = 0; i < vesselType.length; i++) {
            searchList.add(vesselType[i]);
          }
        }
        notifyListeners();
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
