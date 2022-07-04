// To parse this JSON data, do
//
//     final securityQuestionResponse = securityQuestionResponseFromJson(jsonString);

import 'dart:convert';

SecurityQuestionResponse securityQuestionResponseFromJson(String str) =>
    SecurityQuestionResponse.fromJson(json.decode(str));

String securityQuestionResponseToJson(SecurityQuestionResponse data) =>
    json.encode(data.toJson());

class SecurityQuestionResponse {
  SecurityQuestionResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory SecurityQuestionResponse.fromJson(Map<String, dynamic> json) =>
      SecurityQuestionResponse(
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
    required this.description,
    required this.displayOrder,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.getuser,
  });

  int id;
  String? key;
  String value;
  String displayText;
  dynamic description;
  dynamic displayOrder;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;
  List<Getuser> getuser;

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
        getuser:
            List<Getuser>.from(json["getuser"].map((x) => Getuser.fromJson(x))),
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
        "getuser": List<dynamic>.from(getuser.map((x) => x.toJson())),
      };
}

class Getuser {
  Getuser({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.answer,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  int questionId;
  String answer;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Getuser.fromJson(Map<String, dynamic> json) => Getuser(
        id: json["id"],
        userId: json["user_id"],
        questionId: json["question_id"],
        answer: json["answer"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "question_id": questionId,
        "answer": answer,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
