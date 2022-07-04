import 'package:flutter/material.dart';

class GetSelectedFiltersProvider extends ChangeNotifier {
  bool success = false;
  List<String> companyId = [],
      vesselType = [],
      rankList = [],
      nationalityId = [];
  String tentativeJoiningDate = "",
      tentativeEndDate = "",
      expirationStartDate = "",
      expirationEndDate = "";
  Future<bool> callGetFilters(
      header,
      companyId,
      vesselId,
      rankId,
      nationalityList,
      tentativeApidate,
      tentativeEndApiDate,
      expirationStartApiDate,
      expirationEndApiDate) async {
    success = false;
    companyId = [];
    vesselType = [];
    rankList = [];
    nationalityId = [];
    tentativeJoiningDate = "";
    tentativeEndDate = "";
    expirationStartDate = "";
    expirationEndDate = "";
    this.companyId = companyId;
    this.vesselType = vesselId;
    this.rankList = rankId;
    this.nationalityId = nationalityList;
    this.tentativeJoiningDate = tentativeApidate;
    this.tentativeEndDate = tentativeEndApiDate;
    this.expirationStartDate = expirationStartApiDate;
    this.expirationEndDate = expirationEndApiDate;
    return true;
  }
}
