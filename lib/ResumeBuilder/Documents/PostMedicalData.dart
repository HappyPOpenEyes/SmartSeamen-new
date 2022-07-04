// To parse this JSON data, do
//
//     final postMedicalData = postMedicalDataFromJson(jsonString);

import 'dart:convert';

List<PostMedicalData> postMedicalDataFromJson(String str) =>
    List<PostMedicalData>.from(
        json.decode(str).map((x) => PostMedicalData.fromJson(x)));

String postMedicalDataToJson(List<PostMedicalData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostMedicalData {
  PostMedicalData(
      {required this.documentId, required this.hasDocument, required this.id});

  String documentId;
  String id;
  bool hasDocument;

  factory PostMedicalData.fromJson(Map<String, dynamic> json) =>
      PostMedicalData(
          documentId: json["document_id"],
          hasDocument: json["has_document"],
          id: json["id"]);

  Map<String, dynamic> toJson() =>
      {"document_id": documentId, "has_document": hasDocument, "id": id};
}
