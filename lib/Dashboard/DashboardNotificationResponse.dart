// To parse this JSON data, do
//
//     final dashboardNotificationResponse = dashboardNotificationResponseFromJson(jsonString);

import 'dart:convert';

DashboardNotificationResponse dashboardNotificationResponseFromJson(String str) => DashboardNotificationResponse.fromJson(json.decode(str));

String dashboardNotificationResponseToJson(DashboardNotificationResponse data) => json.encode(data.toJson());

class DashboardNotificationResponse {
    DashboardNotificationResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory DashboardNotificationResponse.fromJson(Map<String, dynamic> json) => DashboardNotificationResponse(
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
        required this.customid,
        required this.companyid,
        required this.companyname,
        required this.status,
        required this.subject,
        required this.documentType,
        required this.updatedAt,
    });

    String id;
    String notificationId;
    String customid;
    String companyid;
    String companyname;
    int status;
    String subject;
    String documentType;
    String updatedAt;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        notificationId: json["notification_id"],
        customid: json["customid"],
        companyid: json["companyid"],
        companyname: json["companyname"],
        status: json["status"],
        subject: json["subject"],
        documentType: json["document_type"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "notification_id": notificationId,
        "customid": customid,
        "companyid": companyid,
        "companyname": companyname,
        "status": status,
        "subject": subject,
        "document_type": documentType,
        "updated_at": updatedAt,
    };
}
