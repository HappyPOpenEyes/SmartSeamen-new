import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'AllJobResponse.dart';
import 'JobClass.dart';

class GetJobListProvider extends ChangeNotifier {
  bool success = false, hasMoreData = true;
  bool isSearch = false;
  String searchKeyword = "";
  int offset = 0, numOfJobsApplied = 0;
  late List<JobClass> jobClassData = [], updateJobClassData;
  List<String> companyId = [],
      companyLogo = [],
      companyName = [],
      searchList = [],
      jobExpirationDate = [],
      vesselType = [],
      rankList = [];
  List<bool> isApplied = [], isReferJob = [];
  

  void changeSearch(bool status) {
    isSearch = status;
    notifyListeners();
  }

  void changeOffset() {
    offset++;
    notifyListeners();
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
      expirationEndDate,
      isLoadMore) async {
    success = false;
    if (!isLoadMore) {
      numOfJobsApplied = 0;
      offset = 0;
      isSearch = false;
      hasMoreData = true;
      companyId = [];
      companyLogo = [];
      companyName = [];
      jobExpirationDate = [];
      vesselType = [];
      rankList = [];
      isApplied = [];
      searchList = [];
      jobClassData = [];
      
    }
    var body = {
      "limit": 5,
      "offset": offset,
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
    var response = await http.post(Uri.parse('$apiurl/resume/getalljob'),
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
      AllJobResponse allJobResponse = allJobResponseFromJson(response.body);
      if (allJobResponse.data.jobs.isEmpty) hasMoreData = false;
      for (int i = 0; i < allJobResponse.data.jobs.length; i++) {
        if (allJobResponse.data.jobs[i].referJobStatus == 1) {
          isReferJob.add(true);
        } else {
          isReferJob.add(false);
        }
        companyId.add(allJobResponse.data.jobs[i].companyId);
        if (allJobResponse.data.jobs[i].companyLogo != null) {
          companyLogo.add(allJobResponse.data.jobs[i].companyLogo!);
        } else {
          companyLogo.add("");
        }
        companyName.add(allJobResponse.data.jobs[i].companyName);
        jobExpirationDate.add(allJobResponse.data.jobs[i].jobExpirationDate);
        if (allJobResponse.data.jobs[i].apply == 1) {
          isApplied.add(true);
        } else {
          isApplied.add(false);
        }
        vesselType.add(allJobResponse.data.jobs[i].vesselName);
        rankList.add(allJobResponse.data.jobs[i].getrankdetail);
        jobClassData.add(JobClass(
            companyId: allJobResponse.data.jobs[i].companyId,
            companyName: allJobResponse.data.jobs[i].companyName,
            rankList: allJobResponse.data.jobs[i].getrankdetail,
            vesselList: allJobResponse.data.jobs[i].vesselName,
            jobExpiration: allJobResponse.data.jobs[i].jobExpirationDate,
            isApplied: isApplied[i]));
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
      numOfJobsApplied = allJobResponse.data.applyjobs;
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
