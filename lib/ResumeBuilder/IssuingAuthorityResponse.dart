// To parse this JSON data, do
//
//     final issuingAuthorityResponse = issuingAuthorityResponseFromJson(jsonString);

import 'dart:convert';

IssuingAuthorityResponse issuingAuthorityResponseFromJson(String str) => IssuingAuthorityResponse.fromJson(json.decode(str));

String issuingAuthorityResponseToJson(IssuingAuthorityResponse data) => json.encode(data.toJson());

class IssuingAuthorityResponse {
    IssuingAuthorityResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory IssuingAuthorityResponse.fromJson(Map<String, dynamic> json) => IssuingAuthorityResponse(
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
        required this.issueName,
        required this.documentType,
        required this.isSystemGenerated,
        required this.isApproved,
        required this.isActive,
        required this.createdBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
    });

    String id;
    String issueName;
    DocumentType? documentType;
    int isSystemGenerated;
    int isApproved;
    int isActive;
    String createdBy;
    String? updatedBy;
    DateTime createdAt;
    DateTime updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        issueName: json["issue_name"],
        documentType: documentTypeValues.map[json["document_type"]],
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
        "issue_name": issueName,
        "document_type": documentTypeValues.reverse[documentType],
        "is_system_generated": isSystemGenerated,
        "is_approved": isApproved,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

enum DocumentType { THE_1013, THE_1311, EMPTY }

final documentTypeValues = EnumValues({
    "": DocumentType.EMPTY,
    ",10,13": DocumentType.THE_1013,
    ",13,11": DocumentType.THE_1311
});

class EnumValues<T> {
    late Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap;
        return reverseMap;
    }
}
