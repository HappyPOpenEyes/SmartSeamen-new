// To parse this JSON data, do
//
//     final engineRankResponse = engineRankResponseFromJson(jsonString);

import 'dart:convert';

EngineRankResponse engineRankResponseFromJson(String str) =>
    EngineRankResponse.fromJson(json.decode(str));

String engineRankResponseToJson(EngineRankResponse data) =>
    json.encode(data.toJson());

class EngineRankResponse {
  EngineRankResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory EngineRankResponse.fromJson(Map<String, dynamic> json) =>
      EngineRankResponse(
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
    required this.engine,
    required this.cook,
  });

  List<Cook> engine;
  List<Cook>? cook;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        engine: List<Cook>.from(json["engine"].map((x) => Cook.fromJson(x))),
        cook: json["cook"] == []
            ? null
            : List<Cook>.from(json["cook"].map((x) => Cook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "engine": List<dynamic>.from(engine.map((x) => x.toJson())),
        "cook": List<dynamic>.from(cook!.map((x) => x.toJson())),
      };
}

class Cook {
  Cook({
    required this.id,
    required this.rankName,
    required this.rankOrderId,
    required this.rankType,
    required this.rankDesignation,
    required this.isSystemGenerated,
    required this.isApproved,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String rankName;
  int? rankOrderId;
  int? rankType;
  int? rankDesignation;
  int? isSystemGenerated;
  int? isApproved;
  int? isActive;
  String createdBy;
  String? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Cook.fromJson(Map<String, dynamic> json) => Cook(
        id: json["id"],
        rankName: json["rank_name"],
        rankOrderId: json["rank_order_id"],
        rankType: json["rank_type"],
        rankDesignation: json["rank_designation"],
        isSystemGenerated: json["is_system_generated"],
        isApproved: json["is_approved"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank_name": rankName,
        "rank_order_id": rankOrderId,
        "rank_type": rankType,
        "rank_designation": rankDesignation,
        "is_system_generated": isSystemGenerated,
        "is_approved": isApproved,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
