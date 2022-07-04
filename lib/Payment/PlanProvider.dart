import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'GetPaymentResponse.dart';

class GetPlanListProvider extends ChangeNotifier {
  bool success = false;
  String currentPlanId = "", currentAmount = "";
  List<String> planName = [],
      planId = [],
      planAmount = [],
      planDuration = [],
      planJobViews = [],
      planStripePrice = [];
  List<bool> planCreateProfile = [],
      planDownloadResume = [],
      planJobNotification = [],
      planEmailSupport = [],
      planShortlistNotificaiton = [],
      planJobApplicationPerDay = [],
      planProfileViewNotification = [],
      planProfileHighlightEmployer = [];

  Future<bool> callGetPlanListapi(header) async {
    success = false;
    planName = [];
    planId = [];
    planAmount = [];
    planDuration = [];
    planJobViews = [];
    planCreateProfile = [];
    planStripePrice = [];
    planDownloadResume = [];
    planJobNotification = [];
    planEmailSupport = [];
    planShortlistNotificaiton = [];
    planJobApplicationPerDay = [];
    planProfileViewNotification = [];
    planProfileHighlightEmployer = [];

    try {
      var response =
          await http.get(Uri.parse('$apiurl/payment/getAllPlans'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": header
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        GetPaymentResponse getPaymentResponse =
            getPaymentResponseFromJson(response.body);
        currentPlanId =
            getPaymentResponse.data.userCurrentPlanDetails!.planCrewId;
        for (int i = 0; i < getPaymentResponse.data.plans.length; i++) {
          planAmount
              .add(getPaymentResponse.data.plans[i].planAmount.toString());
          planId.add(getPaymentResponse.data.plans[i].id);
          planName.add(getPaymentResponse.data.plans[i].planName);
          planDuration
              .add(getPaymentResponse.data.plans[i].planDuration.toString());
          planJobViews
              .add(getPaymentResponse.data.plans[i].jobsViews.toString());
          planStripePrice
              .add(getPaymentResponse.data.plans[i].stripePrice ?? '');
          if (getPaymentResponse.data.userCurrentPlanDetails!.planCrewId ==
              getPaymentResponse.data.plans[i].id) {
            currentAmount = getPaymentResponse.data.plans[i].planAmount;
          }
          if (getPaymentResponse.data.plans[i].createProfile == 1) {
            planCreateProfile.add(true);
          } else {
            planCreateProfile.add(false);
          }

          if (getPaymentResponse.data.plans[i].downloadResume == 1) {
            planDownloadResume.add(true);
          } else {
            planDownloadResume.add(false);
          }

          if (getPaymentResponse.data.plans[i].jobNotification == 1) {
            planJobNotification.add(true);
          } else {
            planJobNotification.add(false);
          }

          if (getPaymentResponse.data.plans[i].emailSupport == 1) {
            planEmailSupport.add(true);
          } else {
            planEmailSupport.add(false);
          }

          if (getPaymentResponse.data.plans[i].shortlistNotification == 1) {
            planShortlistNotificaiton.add(true);
          } else {
            planShortlistNotificaiton.add(false);
          }

          if (getPaymentResponse.data.plans[i].jobApplicationPerDay == 1) {
            planJobApplicationPerDay.add(true);
          } else {
            planJobApplicationPerDay.add(false);
          }

          if (getPaymentResponse.data.plans[i].profileViewNotification == 1) {
            planProfileViewNotification.add(true);
          } else {
            planProfileViewNotification.add(false);
          }

          if (getPaymentResponse.data.plans[i].profileHighlightEmployer == 1) {
            planProfileHighlightEmployer.add(true);
          } else {
            planProfileHighlightEmployer.add(false);
          }
        }

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
