// To parse this JSON data, do
//
//     final getProfileResponse = getProfileResponseFromJson(jsonString);

import 'dart:convert';

GetProfileResponse getProfileResponseFromJson(String str) => GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) => json.encode(data.toJson());

class GetProfileResponse {
    GetProfileResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory GetProfileResponse.fromJson(Map<String, dynamic> json) => GetProfileResponse(
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
        required this.roleId,
        required this.companyId,
        required this.firstname,
        required this.lastname,
        required this.mobile,
        required this.email,
    });

    String id;
    int roleId;
    dynamic companyId;
    String firstname;
    String lastname;
    int mobile;
    String email;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        roleId: json["role_id"],
        companyId: json["company_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        mobile: json["mobile"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "company_id": companyId,
        "firstname": firstname,
        "lastname": lastname,
        "mobile": mobile,
        "email": email,
    };
}
