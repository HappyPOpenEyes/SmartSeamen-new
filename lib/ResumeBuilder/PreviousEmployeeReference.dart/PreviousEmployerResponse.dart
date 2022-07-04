// To parse this JSON data, do
//
//     final getEmployerResponse = getEmployerResponseFromJson(jsonString);

import 'dart:convert';

GetEmployerResponse getEmployerResponseFromJson(String str) =>
    GetEmployerResponse.fromJson(json.decode(str));

String getEmployerResponseToJson(GetEmployerResponse data) =>
    json.encode(data.toJson());

class GetEmployerResponse {
  GetEmployerResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory GetEmployerResponse.fromJson(Map<String, dynamic> json) =>
      GetEmployerResponse(
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
    required this.getempref,
  });

  List<Getempref> getempref;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        getempref: List<Getempref>.from(
            json["getempref"].map((x) => Getempref.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "getempref": List<dynamic>.from(getempref.map((x) => x.toJson())),
      };
}

class Getempref {
  Getempref({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.contactPerson,
    required this.contactno,
    required this.countryId,
  });

  String id;
  String userId;
  String companyName;
  String contactPerson;
  int contactno;
  int countryId;

  factory Getempref.fromJson(Map<String, dynamic> json) => Getempref(
        id: json["id"],
        userId: json["user_id"],
        companyName: json["company_name"],
        contactPerson: json["contact_person"],
        contactno: json["contactno"],
        countryId: json["country_id"],
        
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_name": companyName,
        "contact_person": contactPerson,
        "contactno": contactno,
        "country_id": countryId,
        
      };
}
