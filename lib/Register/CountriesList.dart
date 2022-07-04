// To parse this JSON data, do
//
//     final getCountries = getCountriesFromJson(jsonString);

import 'dart:convert';

GetCountries getCountriesFromJson(String str) => GetCountries.fromJson(json.decode(str));

String getCountriesToJson(GetCountries data) => json.encode(data.toJson());

class GetCountries {
    GetCountries({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory GetCountries.fromJson(Map<String, dynamic> json) => GetCountries(
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
        required this.phoneCode,
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
    String phoneCode;

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
        phoneCode: json["PhoneCode"],
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
        "PhoneCode": phoneCode,
    };
}
