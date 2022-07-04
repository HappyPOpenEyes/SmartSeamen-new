// To parse this JSON data, do
//
//     final getDangerousCargoResponse = getDangerousCargoResponseFromJson(jsonString);

import 'dart:convert';

GetDangerousCargoResponse getDangerousCargoResponseFromJson(String str) =>
    GetDangerousCargoResponse.fromJson(json.decode(str));

String getDangerousCargoResponseToJson(GetDangerousCargoResponse data) =>
    json.encode(data.toJson());

class GetDangerousCargoResponse {
  GetDangerousCargoResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory GetDangerousCargoResponse.fromJson(Map<String, dynamic> json) =>
      GetDangerousCargoResponse(
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
    required this.documentId,
    required this.dangerousCargoName,
    required this.id,
    required this.userId,
    required this.documentTypeId,
    required this.hasDocument,
    required this.issuingAuthorityId,
    required this.issueDate,
    this.validTillDate,
    required this.isActive,
    required this.issueName,
    required this.validTillType,
  });

  String documentId;
  String dangerousCargoName;
  String? id;
  String? userId;
  String? documentTypeId;
  int? hasDocument;
  String? issuingAuthorityId;
  dynamic issueDate;
  dynamic validTillDate;
  int? isActive;
  String? issueName;
  int? validTillType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        documentId: json["document_id"],
        dangerousCargoName: json["dangerous_cargo_name"],
        id: json["id"],
        userId: json["user_id"],
        documentTypeId: json["document_type_id"],
        hasDocument: json["has_document"],
        issuingAuthorityId: json["issuing_authority_id"],
        
        issueDate: json["issue_date"] == null ? null : json["issue_date"],
        validTillDate:
            json["valid_till_date"] == null ? null : json["valid_till_date"],
        isActive: json["is_active"],
        issueName: json["issue_name"] == null ? null : json["issue_name"],
        validTillType: json["valid_till_type"],
      );

  Map<String, dynamic> toJson() => {
        "document_id": documentId,
        "dangerous_cargo_name": dangerousCargoName,
        "id": id,
        "user_id": userId,
        "document_type_id": documentTypeId,
        "has_document": hasDocument,
        "issuing_authority_id":
            issuingAuthorityId == null ? null : issuingAuthorityId,
        "issue_date": issueDate,
        "valid_till_date": validTillDate == null
            ? null
            : "${validTillDate.year.toString().padLeft(4, '0')}-${validTillDate.month.toString().padLeft(2, '0')}-${validTillDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "issue_name": issueName == null ? null : issueName,
        "valid_till_type": validTillType == null ? null : validTillType,
      };
}
