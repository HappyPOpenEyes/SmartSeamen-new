// To parse this JSON data, do
//
//     final getSearServiceResponse = getSearServiceResponseFromJson(jsonString);

import 'dart:convert';

GetSearServiceResponse getSearServiceResponseFromJson(String str) =>
    GetSearServiceResponse.fromJson(json.decode(str));

String getSearServiceResponseToJson(GetSearServiceResponse data) =>
    json.encode(data.toJson());

class GetSearServiceResponse {
  GetSearServiceResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory GetSearServiceResponse.fromJson(Map<String, dynamic> json) =>
      GetSearServiceResponse(
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
    required this.getseaservice,
    required this.summary,
  });

  List<Getseaservice> getseaservice;
  List<Summary> summary;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        getseaservice: List<Getseaservice>.from(
            json["getseaservice"].map((x) => Getseaservice.fromJson(x))),
        summary:
            List<Summary>.from(json["summary"].map((x) => Summary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "getseaservice":
            List<dynamic>.from(getseaservice.map((x) => x.toJson())),
        "summary": List<dynamic>.from(summary.map((x) => x.toJson())),
      };
}

class Getseaservice {
  Getseaservice(
      {required this.id,
      required this.userId,
      required this.vesselName,
      required this.vesselType,
      required this.grossTonnage,
      required this.imonumber,
      required this.companyName,
      required this.rankId,
      required this.engineId,
      required this.signOn,
      required this.signOff,
      required this.isActive,
      required this.createdBy,
      required this.updatedBy,
      required this.createdAt,
      required this.updatedAt,
      required this.vessel,
      required this.engineName,
      required this.rankName,
      required this.rankType});

  String id;
  String userId;
  String vesselName;
  String vesselType;
  String companyName;
  String grossTonnage;
  String imonumber;
  String rankId;
  String? engineId;
  DateTime signOn;
  DateTime signOff;
  int isActive;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String vessel;
  String? engineName;
  String rankName;
  int rankType;

  factory Getseaservice.fromJson(Map<String, dynamic> json) => Getseaservice(
      id: json["id"],
      userId: json["user_id"],
      vesselName: json["vessel_name"],
      vesselType: json["vessel_type"],
      companyName: json["company_name"],
      grossTonnage: json["gross_tonnage"],
      imonumber: json["imo_number"],
      rankId: json["rank_id"],
      engineId: json["engine_id"],
      signOn: DateTime.parse(json["sign_on"]),
      signOff: DateTime.parse(json["sign_off"]),
      isActive: json["is_active"],
      createdBy: json["created_by"] == null ? null : json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      vessel: json["vessel"],
      engineName: json["engine_name"] == null ? null : json["engine_name"],
      rankName: json["rank_name"],
      rankType: json["rank_type"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vessel_name": vesselName,
        "vessel_type": vesselType,
        "gross_tonnage": grossTonnage,
        "imo_number": imonumber,
        "company_name": companyName,
        "rank_id": rankId,
        "engine_id": engineId,
        "sign_on":
            "${signOn.year.toString().padLeft(4, '0')}-${signOn.month.toString().padLeft(2, '0')}-${signOn.day.toString().padLeft(2, '0')}",
        "sign_off":
            "${signOff.year.toString().padLeft(4, '0')}-${signOff.month.toString().padLeft(2, '0')}-${signOff.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "vessel": vessel,
        "engine_name": engineName,
        "rank_name": rankName,
        "rank_type": rankType
      };
}

class Summary {
  Summary({
    required this.id,
    required this.rankId,
    required this.rankName,
    required this.signOff,
    required this.signOn,
    required this.totalDuration,
  });

  String id;
  String rankId;
  String rankName;
  DateTime signOff;
  DateTime signOn;
  String totalDuration;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        id: json["id"],
        rankId: json["rank_id"],
        rankName: json["rank_name"],
        signOff: DateTime.parse(json["sign_off"]),
        signOn: DateTime.parse(json["sign_on"]),
        totalDuration: json["total_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank_id": rankId,
        "rank_name": rankName,
        "sign_off":
            "${signOff.year.toString().padLeft(4, '0')}-${signOff.month.toString().padLeft(2, '0')}-${signOff.day.toString().padLeft(2, '0')}",
        "sign_on":
            "${signOn.year.toString().padLeft(4, '0')}-${signOn.month.toString().padLeft(2, '0')}-${signOn.day.toString().padLeft(2, '0')}",
        "total_duration": totalDuration,
      };
}
