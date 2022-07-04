// To parse this JSON data, do
//
//     final dashboardJobResponse = dashboardJobResponseFromJson(jsonString);

import 'dart:convert';

DashboardJobResponse dashboardJobResponseFromJson(String str) => DashboardJobResponse.fromJson(json.decode(str));

String dashboardJobResponseToJson(DashboardJobResponse data) => json.encode(data.toJson());

class DashboardJobResponse {
    DashboardJobResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory DashboardJobResponse.fromJson(Map<String, dynamic> json) => DashboardJobResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.companyName,
        required this.rankName,
        required this.expirationDate,
        required this.vessel,
    });

    String id;
    String companyName;
    String rankName;
    String expirationDate;
    String vessel;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        companyName: json["company_name"],
        rankName: json["rank_name"],
        expirationDate: json["expiration_date"],
        vessel: json["vessel"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "rank_name": rankName,
        "expiration_date": expirationDate,
        "vessel": vessel,
    };
}
