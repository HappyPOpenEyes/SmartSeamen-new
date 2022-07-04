import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'ClientSecretResponse.dart';

class CreatePayment extends ChangeNotifier {
  var clientSecret;
  Future<bool> makeCreatePayment(planid, planamount, header) async {
    print(header);
    try {
    var body = {
      'returnPaymentIntent': 1,
      'amount': planamount,
      'plan_id': planid
    };

    print(body);

    var response = await http.post(Uri.parse('$apiurl/payment/createPayment'),
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
      ClientSecretResponse clientSecretResponse =
          clientSecretResponseFromJson(response.body);
      clientSecret = clientSecretResponse.data.clientSecret;
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
