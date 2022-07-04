// To parse this JSON data, do
//
//     final applyRankResponse = applyRankResponseFromJson(jsonString);

import 'dart:convert';

ApplyRankResponse applyRankResponseFromJson(String str) =>
    ApplyRankResponse.fromJson(json.decode(str));

String applyRankResponseToJson(ApplyRankResponse data) =>
    json.encode(data.toJson());

class ApplyRankResponse {
  ApplyRankResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory ApplyRankResponse.fromJson(Map<String, dynamic> json) =>
      ApplyRankResponse(
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
    required this.rankId,
    required this.rankName,
  });

  String rankId;
  String rankName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rankId: json["rank_id"],
        rankName: json["rank_name"],
      );

  Map<String, dynamic> toJson() => {
        "rank_id": rankId,
        "rank_name": rankName,
      };
}
