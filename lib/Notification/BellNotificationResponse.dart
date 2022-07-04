// To parse this JSON data, do
//
//     final bellNotificationsApi = bellNotificationsApiFromJson(jsonString);

import 'dart:convert';

BellNotificationsApi bellNotificationsApiFromJson(String str) =>
    BellNotificationsApi.fromJson(json.decode(str));

String bellNotificationsApiToJson(BellNotificationsApi data) =>
    json.encode(data.toJson());

class BellNotificationsApi {
  BellNotificationsApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  List<Datum> data;

  factory BellNotificationsApi.fromJson(Map<String, dynamic> json) =>
      BellNotificationsApi(
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
    required this.notificationId,
    required this.dismissStatus,
    required this.status,
    required this.subject,
    required this.documentType,
    required this.updatedAt,
  });

  String id;
  String notificationId;
  int dismissStatus;
  int status;
  String subject;
  String documentType;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        notificationId: json["notification_id"],
        dismissStatus: json["dismiss_status"],
        status: json["status"],
        subject: json["subject"] == null ? null : json["subject"],
        documentType:
            json["document_type"] == null ? null : json["document_type"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_id": notificationId,
        "dismiss_status": dismissStatus,
        "status": status,
        "subject": subject == null ? null : subject,
        "document_type": documentType == null ? null : documentType,
        "updated_at": updatedAt.toIso8601String(),
      };
}
