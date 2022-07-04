// To parse this JSON data, do
//
//     final showAllNotificationsResponse = showAllNotificationsResponseFromJson(jsonString);

import 'dart:convert';

ShowAllNotificationsResponse showAllNotificationsResponseFromJson(String str) =>
    ShowAllNotificationsResponse.fromJson(json.decode(str));

String showAllNotificationsResponseToJson(ShowAllNotificationsResponse data) =>
    json.encode(data.toJson());

class ShowAllNotificationsResponse {
  ShowAllNotificationsResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  List<Datum> data;

  factory ShowAllNotificationsResponse.fromJson(Map<String, dynamic> json) =>
      ShowAllNotificationsResponse(
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
  String updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        notificationId: json["notification_id"],
        dismissStatus: json["dismiss_status"],
        status: json["status"],
        subject: json["subject"] == null ? null : json["subject"],
        documentType:
            json["document_type"] == null ? null : json["document_type"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_id": notificationId,
        "dismiss_status": dismissStatus,
        "status": status,
        "subject": subject == null ? null : subject,
        "document_type": documentType == null ? null : documentType,
        "updated_at": updatedAt,
      };
}
