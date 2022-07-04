// To parse this JSON data, do
//
//     final advancedSearchResponse = advancedSearchResponseFromJson(jsonString);

import 'dart:convert';

AdvancedSearchResponse advancedSearchResponseFromJson(String str) =>
    AdvancedSearchResponse.fromJson(json.decode(str));

String advancedSearchResponseToJson(AdvancedSearchResponse data) =>
    json.encode(data.toJson());

class AdvancedSearchResponse {
  AdvancedSearchResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory AdvancedSearchResponse.fromJson(Map<String, dynamic> json) =>
      AdvancedSearchResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.company,
    required this.rank,
    required this.vessel,
    required this.nationality,
  });

  List<Company> company;
  List<Rank> rank;
  List<Vessel> vessel;
  List<Nationality> nationality;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        company:
            List<Company>.from(json["company"].map((x) => Company.fromJson(x))),
        rank: List<Rank>.from(json["rank"].map((x) => Rank.fromJson(x))),
        vessel:
            List<Vessel>.from(json["vessel"].map((x) => Vessel.fromJson(x))),
        nationality: List<Nationality>.from(
            json["nationality"].map((x) => Nationality.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "company": List<dynamic>.from(company.map((x) => x.toJson())),
        "rank": List<dynamic>.from(rank.map((x) => x.toJson())),
        "vessel": List<dynamic>.from(vessel.map((x) => x.toJson())),
        "nationality": List<dynamic>.from(nationality.map((x) => x.toJson())),
      };
}

class Company {
  Company({
    required this.id,
    required this.companyId,
    required this.companyName,
  });

  String id;
  String companyId;
  String companyName;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyId: json["company_id"],
        companyName: json["company_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "company_name": companyName,
      };
}

class Nationality {
  Nationality({
    required this.id,
    required this.nationalityName,
  });

  String id;
  String nationalityName;

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
        id: json["id"],
        nationalityName: json["nationality_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nationality_name": nationalityName,
      };
}

class Rank {
  Rank({
    required this.id,
    required this.rankId,
    required this.rankName,
  });

  String id;
  String rankId;
  String rankName;

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"],
        rankId: json["rank_id"],
        rankName: json["rank_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank_id": rankId,
        "rank_name": rankName,
      };
}

class Vessel {
  Vessel({
    required this.id,
    required this.vesselName,
  });

  String id;
  String vesselName;

  factory Vessel.fromJson(Map<String, dynamic> json) => Vessel(
        id: json["id"],
        vesselName: json["vessel_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vessel_name": vesselName,
      };
}
