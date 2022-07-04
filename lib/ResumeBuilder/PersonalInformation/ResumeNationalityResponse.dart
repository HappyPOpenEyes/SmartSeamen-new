// To parse this JSON data, do
//
//     final resumeNationalityResponse = resumeNationalityResponseFromJson(jsonString);

import 'dart:convert';

ResumeNationalityResponse resumeNationalityResponseFromJson(String str) =>
    ResumeNationalityResponse.fromJson(json.decode(str));

String resumeNationalityResponseToJson(ResumeNationalityResponse data) =>
    json.encode(data.toJson());

class ResumeNationalityResponse {
  ResumeNationalityResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory ResumeNationalityResponse.fromJson(Map<String, dynamic> json) =>
      ResumeNationalityResponse(
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
    required this.nationalityName,
    required this.isSystemGenerated,
    required this.isApproved,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String nationalityName;
  int? isSystemGenerated;
  int? isApproved;
  int? isActive;
  String? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nationalityName: json["nationality_name"],
        isSystemGenerated: json["is_system_generated"] == null
            ? null
            : json["is_system_generated"],
        isApproved: json["is_approved"] == null ? null : json["is_approved"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nationality_name": nationalityName,
        "is_system_generated":
            isSystemGenerated == null ? null : isSystemGenerated,
        "is_approved": isApproved == null ? null : isApproved,
        "is_active": isActive == null ? null : isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
