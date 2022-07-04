// To parse this JSON data, do
//
//     final calculatedPaymentResponse = calculatedPaymentResponseFromJson(jsonString);

import 'dart:convert';

CalculatedPaymentResponse calculatedPaymentResponseFromJson(String str) =>
    CalculatedPaymentResponse.fromJson(json.decode(str));

String calculatedPaymentResponseToJson(CalculatedPaymentResponse data) =>
    json.encode(data.toJson());

class CalculatedPaymentResponse {
  CalculatedPaymentResponse({
    this.calculatedAmount,
    required this.startDate,
    required this.endDate,
  });

  dynamic calculatedAmount;
  String startDate;
  String endDate;

  factory CalculatedPaymentResponse.fromJson(Map<String, dynamic> json) =>
      CalculatedPaymentResponse(
        calculatedAmount: json["calculatedAmount"],
        startDate: json["startDate"],
        endDate: json["endDate"],
      );

  Map<String, dynamic> toJson() => {
        "calculatedAmount": calculatedAmount,
        "startDate": startDate,
        "endDate": endDate,
      };
}
