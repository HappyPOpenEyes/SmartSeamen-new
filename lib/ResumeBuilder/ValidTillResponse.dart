// To parse this JSON data, do
//
//     final validTillDate = validTillDateFromJson(jsonString);

import 'dart:convert';

ValidTillDate validTillDateFromJson(String str) => ValidTillDate.fromJson(json.decode(str));

String validTillDateToJson(ValidTillDate data) => json.encode(data.toJson());

class ValidTillDate {
    ValidTillDate({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory ValidTillDate.fromJson(Map<String, dynamic> json) => ValidTillDate(
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
        required this.key,
        required this.value,
        required this.displayText,
        this.description,
        this.displayOrder,
        required this.isActive,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String key;
    String value;
    String displayText;
    dynamic description;
    dynamic displayOrder;
    int isActive;
    dynamic createdBy;
    dynamic updatedBy;
    dynamic createdAt;
    dynamic updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        displayText: json["display_text"],
        description: json["description"],
        displayOrder: json["display_order"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "display_text": displayText,
        "description": description,
        "display_order": displayOrder,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
