// To parse this JSON data, do
//
//     final postVisaData = postVisaDataFromJson(jsonString);

import 'dart:convert';

List<PostVisaData> postVisaDataFromJson(String str) => List<PostVisaData>.from(
    json.decode(str).map((x) => PostVisaData.fromJson(x)));

String postVisaDataToJson(List<PostVisaData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostVisaData {
  PostVisaData(
      {required this.validTillDate,
      required this.validTillType,
      required this.issueDate,
      required this.configurationId,
      required this.countryId,
      required this.id});

  String validTillDate;
  String validTillType;
  String issueDate;
  String id;
  String configurationId;
  String countryId;

  factory PostVisaData.fromJson(Map<String, dynamic> json) => PostVisaData(
      validTillDate: json["valid_till_date"],
      issueDate: json["issue_date"],
      validTillType: json["valid_till_type"],
      configurationId: json["configration_id"],
      countryId: json["country_id"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "valid_till_date": validTillDate,
        "issue_date": issueDate,
        "id": id,
        "configration_id": configurationId,
        "country_id": countryId,
        "valid_till_type": validTillType
      };
}
