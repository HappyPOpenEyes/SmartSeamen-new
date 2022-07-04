// To parse this JSON data, do
//
//     final postEmployerResponse = postEmployerResponseFromJson(jsonString);

import 'dart:convert';

PostEmployerResponse postEmployerResponseFromJson(String str) =>
    PostEmployerResponse.fromJson(json.decode(str));

String postEmployerResponseToJson(PostEmployerResponse data) =>
    json.encode(data.toJson());

class PostEmployerResponse {
  PostEmployerResponse({
    required this.references,
  });

  List<Reference> references;

  factory PostEmployerResponse.fromJson(Map<String, dynamic> json) =>
      PostEmployerResponse(
        references: List<Reference>.from(
            json["references"].map((x) => Reference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "references": List<dynamic>.from(references.map((x) => x.toJson())),
      };
}

class Reference {
  Reference({
    required this.companyName,
    required this.contactPerson,
    required this.contactno,
    required this.countryId,
  });

  String companyName;
  String contactPerson;
  String contactno;
  String countryId;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        companyName: json["company_name"],
        contactPerson: json["contact_person"],
        contactno: json["contactno"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "contact_person": contactPerson,
        "contactno": contactno,
        "country_id": countryId,
      };
}
