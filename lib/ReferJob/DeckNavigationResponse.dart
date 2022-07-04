// To parse this JSON data, do
//
//     final deckNavigationResponse = deckNavigationResponseFromJson(jsonString);

import 'dart:convert';

DeckNavigationResponse deckNavigationResponseFromJson(String str) => DeckNavigationResponse.fromJson(json.decode(str));

String deckNavigationResponseToJson(DeckNavigationResponse data) => json.encode(data.toJson());

class DeckNavigationResponse {
    DeckNavigationResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory DeckNavigationResponse.fromJson(Map<String, dynamic> json) => DeckNavigationResponse(
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
    int rankOrderId;
    int rankType;
    int rankDesignation;
    int isSystemGenerated;
    int isApproved;
    int isActive;
    String createdBy;
    String updatedBy;
    DateTime createdAt;
    DateTime updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        rankName: json["rank_name"],
        rankOrderId: json["rank_order_id"],
        rankType: json["rank_type"],
        rankDesignation: json["rank_designation"],
        isSystemGenerated: json["is_system_generated"],
        isApproved: json["is_approved"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
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
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
