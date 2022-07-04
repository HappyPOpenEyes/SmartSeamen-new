// To parse this JSON data, do
//
//     final registerApi = registerApiFromJson(jsonString);

import 'dart:convert';

RegisterApi registerApiFromJson(String str) => RegisterApi.fromJson(json.decode(str));

String registerApiToJson(RegisterApi data) => json.encode(data.toJson());

class RegisterApi {
    RegisterApi({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    String data;

    factory RegisterApi.fromJson(Map<String, dynamic> json) => RegisterApi(
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
