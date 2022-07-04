// To parse this JSON data, do
//
//     final postCompetencyData = postCompetencyDataFromJson(jsonString);

import 'dart:convert';

List<PostCompetencyData> postCompetencyDataFromJson(String str) =>
    List<PostCompetencyData>.from(
        json.decode(str).map((x) => PostCompetencyData.fromJson(x)));

String postCompetencyDataToJson(List<PostCompetencyData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostCompetencyData {
  PostCompetencyData(
      {required this.certificateNo,
      required this.issuingAuthorityId,
      required this.validTillDate,
      required this.validTillType,
      required this.issueDate,
      required this.rankDocumentId,
      required this.id});

  String certificateNo;
  String issuingAuthorityId;
  String validTillDate;
  String validTillType;
  String issueDate;
  String id;
  String rankDocumentId;

  factory PostCompetencyData.fromJson(Map<String, dynamic> json) =>
      PostCompetencyData(
        certificateNo: json["certificate_no"],
        issuingAuthorityId: json["issuing_authority_id"],
        validTillDate: json["valid_till_date"],
        validTillType: json["valid_till_type"],
        issueDate: json["issue_date"],
        id: json["id"],
        rankDocumentId: json["rank_document_id"],
      );

  Map<String, dynamic> toJson() => {
        "certificate_no": certificateNo,
        "issuing_authority_id": issuingAuthorityId,
        "valid_till_date": validTillDate,
        "valid_till_type": validTillType,
        "issue_date": issueDate,
        "id": id,
        "rank_document_id": rankDocumentId
      };
}
