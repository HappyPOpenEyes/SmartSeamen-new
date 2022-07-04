import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'GetPaymentRedirectResponse.dart';

class PaymentRedirectUrlProvider extends ChangeNotifier {
  bool success = false;
  String hash = "", txnid = "", surl = "", furl = "", merchantId = "", merchantKey = "";
  Future<bool> callPaymentRedirectUrlapi(firstname, lastname, email, phone,
      userid, planname, amount, planid, planDuration, header) async {
    try {
      var body = {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "udf5": userid,
        "plan_duration": planDuration,
        "productinfo": planname,
        "amount": amount,
        "plan_id": planid
      };

      print(body);
      var response = await http.post(Uri.parse(apiurl + '/payment/redirectURL'),
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
        GetPaymentRedirectResponse getPaymentRedirectResponse =
            getPaymentRedirectResponseFromJson(response.body);
        hash = getPaymentRedirectResponse.data.hash;
        txnid = getPaymentRedirectResponse.data.txnid;
        surl = getPaymentRedirectResponse.data.surl;
        furl = getPaymentRedirectResponse.data.furl;
        merchantKey = getPaymentRedirectResponse.data.key;
        merchantId = getPaymentRedirectResponse.data.salt;
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
