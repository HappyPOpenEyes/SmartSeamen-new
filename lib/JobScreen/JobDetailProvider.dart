import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'JobDetailResponse.dart';

class GetJobDetailProvider extends ChangeNotifier {
  bool success = false;
  int currentIndex = 0;
  List<int> countryCount = [];
  List<String> tentaiveJoiningDate = [],
      nationality = [],
      jobExpirationDate = [],
      description = [],
      jobId = [];
  List<List<String>> navigationRankDetail = [],
      deckexperienceYears = [],
      navexperienceYears = [],
      deckRankDetail = [],
      vesselType = [];
  List<List<List<String>>> navigationCountries = [], deckCountries = [];
  String companyId = "", companyName = "";
  List<bool> isApplied = [];

  void increaseLength() {
    currentIndex++;
    notifyListeners();
  }

  void decreaseLength() {
    currentIndex--;
    notifyListeners();
  }

  Future<bool> callGetJobDetailapi(postcompanyid, header) async {
    currentIndex = 0;
    countryCount = [];
    tentaiveJoiningDate = [];
    nationality = [];
    jobExpirationDate = [];
    vesselType = [];
    deckexperienceYears = [];
    navexperienceYears = [];
    deckRankDetail = [];
    deckCountries = [];
    navigationCountries = [];
    navigationRankDetail = [];
    description = [];
    jobId = [];
    companyId = "";
    companyName = "";
    isApplied = [];
    print(postcompanyid);

    //try {
    var response = await http.get(
      Uri.parse(apiurl + '/resume/getbyjobid/' + postcompanyid),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      },
    );

    print(response.statusCode);
    print(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      JobDetailResponse jobDetailResponse =
          jobDetailResponseFromJson(response.body);
      List<List<String>> deckCountryList = [], navCountryList = [];
      for (int i = 0; i < jobDetailResponse.data.length; i++) {
        jobId.add(jobDetailResponse.data[i].id);
        companyId = jobDetailResponse.data[i].companyId;
        companyName = jobDetailResponse.data[i].companyName;
        jobExpirationDate.add(jobDetailResponse.data[i].exptirationDate);
        tentaiveJoiningDate.add(jobDetailResponse.data[i].tentativeJoiningDate);
        print(jobDetailResponse.data[i].description);
        final document = parse(jobDetailResponse.data[i].description);
        description.add(parse(document.body!.text).documentElement!.text);
        String nationalities = "";
        List<String> deckRanks = [],
            navigationRanks = [],
            innerdeckCountries = [],
            innernavCountries = [],
            deckexperiences = [],
            navexperiences = [];
        for (int j = 0;
            j < jobDetailResponse.data[i].nationalityName.length;
            j++) {
          nationalities =
              nationalities + jobDetailResponse.data[i].nationalityName[j];
        }
        nationality.add(nationalities);
        if (jobDetailResponse.data[i].apply == 1)
          isApplied.add(true);
        else
          isApplied.add(false);
        vesselType.add(jobDetailResponse.data[i].vesselName);
        print('Rank Length is');
        print(jobDetailResponse.data[i].getrankdetail.length);
        for (int j = 0;
            j < jobDetailResponse.data[i].getrankdetail.length;
            j++) {
          print('Inside');
          print(jobDetailResponse.data[i].getrankdetail.length);
          deckexperiences.add(
              jobDetailResponse.data[i].getrankdetail[j].experience.toString());
          deckRanks.add(jobDetailResponse.data[i].getrankdetail[j].rank);
        }
        deckRankDetail.add(deckRanks);
        deckexperienceYears.add(deckexperiences);
        for (int j = 0;
            j < jobDetailResponse.data[i].getrankdetail1.length;
            j++) {
          print(jobDetailResponse.data[i].getrankdetail1.length);
          navexperiences.add(jobDetailResponse
              .data[i].getrankdetail1[j].experience
              .toString());
          navigationRanks.add(jobDetailResponse.data[i].getrankdetail1[j].rank);
        }
        navigationRankDetail.add(navigationRanks);
        navexperienceYears.add(navexperiences);
        for (int j = 0;
            j < jobDetailResponse.data[i].getrankdetail1.length;
            j++) {
          innernavCountries = [];
          for (int k = 0;
              k < jobDetailResponse.data[i].getrankdetail1[j].cocIssuing.length;
              k++) {
            innernavCountries.add(jobDetailResponse
                .data[i].getrankdetail1[j].cocIssuing[k].issueName);
          }
          navCountryList.add(innernavCountries);
        }

        for (int j = 0;
            j < jobDetailResponse.data[i].getrankdetail.length;
            j++) {
          innerdeckCountries = [];
          countryCount.add(
              jobDetailResponse.data[i].getrankdetail[j].cocIssuing.length);
          for (int k = 0;
              k < jobDetailResponse.data[i].getrankdetail[j].cocIssuing.length;
              k++) {
            innerdeckCountries.add(jobDetailResponse
                .data[i].getrankdetail[j].cocIssuing[k].issueName);
          }
          deckCountryList.add(innerdeckCountries);
        }
      }

      deckCountries.add(deckCountryList);
      navigationCountries.add(navCountryList);

      return success = true;
    } else if (response.statusCode == 422) {
      return success = false;
    } else {
      return success = false;
    }
    // } catch (err) {
    //   print(err.toString());
    //   return success = false;
    // }
  }
}
