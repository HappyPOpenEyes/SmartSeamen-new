// To parse this JSON data, do
//
//     final postCdcData = postCdcDataFromJson(jsonString);

import 'dart:convert';

List<PostCdcData> postCdcDataFromJson(String str) => List<PostCdcData>.from(
    json.decode(str).map((x) => PostCdcData.fromJson(x)));

String postCdcDataToJson(List<PostCdcData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostCdcData {
  PostCdcData(
      {required this.issueDate,
      required this.validTillDate,
      required this.validTillType,
      required this.documentType,
      required this.documentNo,
      required this.issuingAuthorityId,
      required this.configurationId,
      required this.id});

  String issueDate;
  String validTillDate;
  String validTillType;
  String documentType;
  String documentNo;
  String configurationId;
  String issuingAuthorityId;
  String id;

  factory PostCdcData.fromJson(Map<String, dynamic> json) => PostCdcData(
      issueDate: json["issue_date"],
      validTillDate: json["valid_till_date"],
      documentType: json["document_type"],
      documentNo: json["document_no"],
      issuingAuthorityId: json["issuing_authority_id"],
      validTillType: json["valid_till_type"],
      configurationId: json["configration_id"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "issue_date": issueDate,
        "valid_till_date": validTillDate,
        "valid_till_type": validTillType,
        "document_type": documentType,
        "document_no": documentNo,
        "issuing_authority_id": issuingAuthorityId,
        "configration_id": configurationId,
        "id": id,
      };
}
