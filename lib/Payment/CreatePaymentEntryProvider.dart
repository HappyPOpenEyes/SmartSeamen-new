import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class CreatePaymentEntry extends ChangeNotifier {
  Future<bool> makeCreatePaymentEntry(
      planamount,
      planStripePrice,
      planId,
      planName,
      planDuration,
      paymentIntentId,
      paymentMethodId,
      planStartDate,
      planEndDate,
      planCalculatedAmount,
      clientSecret,
      status,
      header) async {
    try {
      var body = {
        "paymentIntent": {
          "id": paymentIntentId,
          "amount": planamount,
          "status": status
        },
        "paymentCustomEntity": {
          'returnPaymentIntent': 0,
          'amount': planamount,
          'stripe_plan': planStripePrice,
          'plan_id': planId,
          'plan_name': planName,
          'plan_duration': planDuration,
          'intent_id': paymentIntentId,
          'payment_method': paymentMethodId,
          'plan_start_date': planStartDate,
          'plan_end_date': planEndDate,
          'calculatedAmount': planCalculatedAmount
        }
      };
      print(body);

      var response =
          await http.post(Uri.parse('$apiurl/payment/createPayment'),
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
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
}
