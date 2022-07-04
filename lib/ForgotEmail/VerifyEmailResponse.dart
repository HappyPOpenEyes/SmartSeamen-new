// To parse this JSON data, do
//
//     final verifyNumberResponse = verifyNumberResponseFromJson(jsonString);

import 'dart:convert';

VerifyNumberResponse verifyNumberResponseFromJson(String str) => VerifyNumberResponse.fromJson(json.decode(str));

String verifyNumberResponseToJson(VerifyNumberResponse data) => json.encode(data.toJson());

class VerifyNumberResponse {
    VerifyNumberResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    String data;

    factory VerifyNumberResponse.fromJson(Map<String, dynamic> json) => VerifyNumberResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data,
    };
}
