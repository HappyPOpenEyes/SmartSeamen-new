import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'CalculatedPaymentResponse.dart';

class GetPlanCalculationProvider extends ChangeNotifier {
  bool success = false, isAlreadyPlan = false;
  var calculatedPlanAmount = "", startDate = "", endDate = "";
  Future<bool> callGetPlanListapi(id, header) async {
    success = false;
    isAlreadyPlan = false;
    try {
      var response = await http.get(
          Uri.parse('$apiurl/payment/calculatePlanAmount/$id'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header
          });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        CalculatedPaymentResponse calculatedPaymentResponse =
            calculatedPaymentResponseFromJson(response.body);
        calculatedPlanAmount =
            calculatedPaymentResponse.calculatedAmount.toString();
        startDate = calculatedPaymentResponse.startDate;
        endDate = calculatedPaymentResponse.endDate;
        return success = true;
      } else if (response.statusCode == 400) {
        isAlreadyPlan = true;
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
