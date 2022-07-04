// To parse this JSON data, do
//
//     final getResumeCountryResponse = getResumeCountryResponseFromJson(jsonString);

import 'dart:convert';

GetResumeCountryResponse getResumeCountryResponseFromJson(String str) => GetResumeCountryResponse.fromJson(json.decode(str));

String getResumeCountryResponseToJson(GetResumeCountryResponse data) => json.encode(data.toJson());

class GetResumeCountryResponse {
    GetResumeCountryResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory GetResumeCountryResponse.fromJson(Map<String, dynamic> json) => GetResumeCountryResponse(
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
        required this.countryName,
        required this.countryAbbreviation,
        required this.phonePrefix,
        required this.isActive,
        required this.createdBy,
        required this.createdOn,
        required this.updatedBy,
        required this.updatedOn,
    });

    int id;
    String countryName;
    String countryAbbreviation;
    String phonePrefix;
    int isActive;
    int createdBy;
    DateTime createdOn;
    int updatedBy;
    DateTime updatedOn;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        countryName: json["country_name"],
        countryAbbreviation: json["country_abbreviation"],
        phonePrefix: json["phone_prefix"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(json["UpdatedOn"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "country_abbreviation": countryAbbreviation,
        "phone_prefix": phonePrefix,
        "is_active": isActive,
        "created_by": createdBy,
        "CreatedOn": createdOn.toIso8601String(),
        "updated_by": updatedBy,
        "UpdatedOn": updatedOn.toIso8601String(),
    };
}
