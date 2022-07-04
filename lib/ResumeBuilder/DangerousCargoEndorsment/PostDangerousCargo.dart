// To parse this JSON data, do
//
//     final posttDangerousCargoResponse = posttDangerousCargoResponseFromJson(jsonString);

import 'dart:convert';

List<PosttDangerousCargoResponse> posttDangerousCargoResponseFromJson(
        String str) =>
    List<PosttDangerousCargoResponse>.from(
        json.decode(str).map((x) => PosttDangerousCargoResponse.fromJson(x)));

String posttDangerousCargoResponseToJson(
        List<PosttDangerousCargoResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PosttDangerousCargoResponse {
  PosttDangerousCargoResponse(
      {required this.dangerousCargoName,
      required this.documentId,
      required this.hasDocument,
      this.id,
      required this.issuingAuthorityId,
      required this.issueName,
      required this.issueDate,
      required this.validTillDate,
      required this.validTillType});

  String dangerousCargoName;
  String documentId;
  bool hasDocument;
  dynamic id;
  String issuingAuthorityId;
  String issueName;
  String issueDate;
  String validTillDate;
  String validTillType;

  factory PosttDangerousCargoResponse.fromJson(Map<String, dynamic> json) =>
      PosttDangerousCargoResponse(
          dangerousCargoName: json["dangerous_cargo_name"],
          documentId: json["document_id"],
          hasDocument: json["has_document"],
          id: json["id"],
          issuingAuthorityId: json["issuing_authority_id"],
          issueDate: json["issue_date"],
          validTillDate: json["valid_till_date"],
          validTillType: json["valid_till_type"],
          issueName: json["issue_name"]);

  Map<String, dynamic> toJson() => {
        "dangerous_cargo_name": dangerousCargoName,
        "document_id": documentId,
        "has_document": hasDocument,
        "id": id,
        "issuing_authority_id": issuingAuthorityId,
        "issue_date": issueDate,
        "valid_till_date": validTillDate,
        "valid_till_type": validTillType,
        "issue_name": issueName
      };
}
