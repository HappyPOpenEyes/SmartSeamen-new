// To parse this JSON data, do
//
//     final dashboardCountDataResponse = dashboardCountDataResponseFromJson(jsonString);

import 'dart:convert';

DashboardCountDataResponse dashboardCountDataResponseFromJson(String str) => DashboardCountDataResponse.fromJson(json.decode(str));

String dashboardCountDataResponseToJson(DashboardCountDataResponse data) => json.encode(data.toJson());

class DashboardCountDataResponse {
    DashboardCountDataResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    Data data;

    factory DashboardCountDataResponse.fromJson(Map<String, dynamic> json) => DashboardCountDataResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.totaljobs,
        required this.availablejob,
        required this.appliedjob,
        required this.shortlistcount,
        required this.publishstatus,
        required this.onboardstatus,
    });

    int totaljobs;
    int availablejob;
    int appliedjob;
    int shortlistcount;
    int? publishstatus;
    int? onboardstatus;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totaljobs: json["totaljobs"],
        availablejob: json["availablejob"],
        appliedjob: json["appliedjob"],
        shortlistcount: json["shortlistcount"],
        publishstatus: json["publishstatus"] ?? 0,
        onboardstatus: json["onboardstatus"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "totaljobs": totaljobs,
        "availablejob": availablejob,
        "appliedjob": appliedjob,
        "shortlistcount": shortlistcount,
        "publishstatus": publishstatus,
        "onboardstatus": onboardstatus,
    };
}
