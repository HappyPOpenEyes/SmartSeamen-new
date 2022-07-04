// To parse this JSON data, do
//
//     final postStcwData = postStcwDataFromJson(jsonString);

import 'dart:convert';

List<PostStcwData> postStcwDataFromJson(String str) => List<PostStcwData>.from(
    json.decode(str).map((x) => PostStcwData.fromJson(x)));

String postStcwDataToJson(List<PostStcwData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostStcwData {
  PostStcwData({
    required this.validDate,
    required this.issueDate,
    required this.validType,
    required this.documentId,
    required this.certificateNo,
    required this.id,
  });

  String validDate;
  String issueDate;
  String validType;
  String documentId;
  String certificateNo;
  String id;

  factory PostStcwData.fromJson(Map<String, dynamic> json) => PostStcwData(
        validDate: json["valid_date"],
        issueDate: json["issue_date"],
        validType: json["valid_till_type"],
        documentId: json["document_id"],
        certificateNo: json["certificate_no"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "valid_date": validDate,
        "issue_date": issueDate,
        "valid_till_type": validType,
        "document_id": documentId,
        "certificate_no": certificateNo,
        "id": id,
      };
}
