import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'PaymentHistoryResponse.dart';

class PlanHistoryProvider extends ChangeNotifier {
  String currentPlanName = "",
      currentPlanStartDate = "",
      currentPlanExpiryDate = "",
      currentPlanAmount = "";
  List<String> upcomingPlanName = [],
      upcomingPlanStartDate = [],
      upcomingPlanExpiryDate = [],
      upcomingPlanAmount = [],
      upcomingPlanDuration = [],
      upcomingPlanStatus = [];
  List<String> pastPlanName = [],
      pastPlanStartDate = [],
      pastPlanExpiryDate = [],
      pastPlanAmount = [],
      pastPlanDuration = [],
      pastPlanStatus = [];
  bool success = false;
  Future<bool> callPlanHistoryapi(header) async {
    currentPlanName = "";
    currentPlanStartDate = "";
    currentPlanExpiryDate = "";
    currentPlanAmount = "";
    upcomingPlanName = [];
    upcomingPlanStartDate = [];
    upcomingPlanExpiryDate = [];
    upcomingPlanAmount = [];
    pastPlanName = [];
    pastPlanStartDate = [];
    pastPlanExpiryDate = [];
    pastPlanAmount = [];
    try {
      var response = await http
          .get(Uri.parse('$apiurl/payment/getUserPaymentdetails'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        PaymentHistoryResponse getPaymentHistoryResponse =
            paymentHistoryResponseFromJson(response.body);
        currentPlanAmount =
            getPaymentHistoryResponse.data.currentplan.planAmount.toString();
        currentPlanExpiryDate =
            getPaymentHistoryResponse.data.currentplan.planExpiryDate;
        currentPlanName = getPaymentHistoryResponse.data.currentplan.planCrewId;
        currentPlanStartDate =
            getPaymentHistoryResponse.data.currentplan.planStartDate;
        for (int i = 0;
            i < getPaymentHistoryResponse.data.pastplan.length;
            i++) {
          var str = getPaymentHistoryResponse.data.pastplan[i].planAmount
              .toString()
              .split('.');
          pastPlanAmount.add(str[0]);
          pastPlanExpiryDate
              .add(getPaymentHistoryResponse.data.pastplan[i].planExpiryDate!);
          pastPlanName
              .add(getPaymentHistoryResponse.data.pastplan[i].planCrewName);
          pastPlanStartDate
              .add(getPaymentHistoryResponse.data.pastplan[i].planStartDate!);
          pastPlanStatus
              .add(getPaymentHistoryResponse.data.pastplan[i].paymentStatus);
          pastPlanDuration.add(getPaymentHistoryResponse
              .data.pastplan[i].planDuration
              .toString());
        }
        for (int i = 0;
            i < getPaymentHistoryResponse.data.upcomingplan.length;
            i++) {
          var str = getPaymentHistoryResponse.data.upcomingplan[i].planAmount
              .toString()
              .split('.');
          upcomingPlanAmount.add(str[0]);
          upcomingPlanExpiryDate.add(
              getPaymentHistoryResponse.data.upcomingplan[i].planExpiryDate!);
          upcomingPlanName
              .add(getPaymentHistoryResponse.data.upcomingplan[i].planCrewName);
          upcomingPlanStartDate.add(
              getPaymentHistoryResponse.data.upcomingplan[i].planStartDate!);
          upcomingPlanStatus.add(
              getPaymentHistoryResponse.data.upcomingplan[i].paymentStatus);
          upcomingPlanDuration.add(getPaymentHistoryResponse
              .data.upcomingplan[i].planDuration
              .toString());
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
      return success = false;
    }
  }
}
