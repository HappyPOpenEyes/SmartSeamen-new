// To parse this JSON data, do
//
//     final userQuestionResponse = userQuestionResponseFromJson(jsonString);

import 'dart:convert';

UserQuestionResponse userQuestionResponseFromJson(String str) =>
    UserQuestionResponse.fromJson(json.decode(str));

String userQuestionResponseToJson(UserQuestionResponse data) =>
    json.encode(data.toJson());

class UserQuestionResponse {
  UserQuestionResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory UserQuestionResponse.fromJson(Map<String, dynamic> json) =>
      UserQuestionResponse(
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
    required this.userId,
    required this.id,
    required this.displayText,
  });

  String userId;
  int id;
  String displayText;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        id: json["id"],
        displayText: json["display_text"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "id": id,
        "display_text": displayText,
      };
}
