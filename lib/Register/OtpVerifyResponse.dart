// To parse this JSON data, do
//
//     final otpVerifyResponse = otpVerifyResponseFromJson(jsonString);

import 'dart:convert';

OtpVerifyResponse otpVerifyResponseFromJson(String str) => OtpVerifyResponse.fromJson(json.decode(str));

String otpVerifyResponseToJson(OtpVerifyResponse data) => json.encode(data.toJson());

class OtpVerifyResponse {
    OtpVerifyResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    String data;

    factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) => OtpVerifyResponse(
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
