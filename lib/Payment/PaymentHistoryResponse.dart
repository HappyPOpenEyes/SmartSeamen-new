// To parse this JSON data, do
//
//     final paymentHistoryResponse = paymentHistoryResponseFromJson(jsonString);

import 'dart:convert';

PaymentHistoryResponse paymentHistoryResponseFromJson(String str) =>
    PaymentHistoryResponse.fromJson(json.decode(str));

String paymentHistoryResponseToJson(PaymentHistoryResponse data) =>
    json.encode(data.toJson());

class PaymentHistoryResponse {
  PaymentHistoryResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryResponse(
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
    required this.currentplan,
    required this.upcomingplan,
    required this.pastplan,
  });

  Currentplan currentplan;
  List<Plan> upcomingplan;
  List<Plan> pastplan;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentplan: Currentplan.fromJson(json["currentplan"]),
        upcomingplan:
            List<Plan>.from(json["upcomingplan"].map((x) => Plan.fromJson(x))),
        pastplan:
            List<Plan>.from(json["pastplan"].map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currentplan": currentplan.toJson(),
        "upcomingplan": List<dynamic>.from(upcomingplan.map((x) => x.toJson())),
        "pastplan": List<dynamic>.from(pastplan.map((x) => x.toJson())),
      };
}

class Currentplan {
  Currentplan({
    required this.id,
    required this.planCrewId,
    required this.planStartDate,
    required this.planExpiryDate,
    required this.planExpiryDates,
    required this.planAmount,
    required this.isActive,
  });

  String id;
  String planCrewId;
  String planStartDate;
  String planExpiryDate;
  DateTime? planExpiryDates;
  String planAmount;
  int isActive;

  factory Currentplan.fromJson(Map<String, dynamic> json) => Currentplan(
        id: json["id"],
        planCrewId: json["plan_crew_id"],
        planStartDate: json["plan_start_date"],
        planExpiryDate: json["plan_expiry_date"],
        planExpiryDates: json["plan_expiry_dates"] == null
            ? null
            : DateTime.parse(json["plan_expiry_dates"]),
        planAmount: json["plan_amount"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_crew_id": planCrewId,
        "plan_start_date": planStartDate,
        "plan_expiry_date": planExpiryDate,
        "plan_expiry_dates": planExpiryDates!.toIso8601String(),
        "plan_amount": planAmount,
        "is_active": isActive,
      };
}

class Plan {
  Plan({
    required this.id,
    required this.planCrewId,
    required this.planCrewName,
    required this.userId,
    required this.paymentStatus,
    required this.planDuration,
    required this.planStartDate,
    required this.planExpiryDate,
    required this.planAmount,
    required this.isActive,
    required this.updatedAt,
  });

  String id;
  String planCrewId;
  String planCrewName;
  String userId;
  String paymentStatus;
  int planDuration;
  String? planStartDate;
  String? planExpiryDate;
  String planAmount;
  int isActive;
  String updatedAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        planCrewId: json["plan_crew_id"],
        planCrewName: json["plan_crew_name"],
        userId: json["user_id"],
        paymentStatus: json["payment_status"],
        planDuration: json["plan_duration"],
        planStartDate:
            json["plan_start_date"] == null ? null : json["plan_start_date"],
        planExpiryDate:
            json["plan_expiry_date"] == null ? null : json["plan_expiry_date"],
        planAmount: json["plan_amount"],
        isActive: json["is_active"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_crew_id": planCrewId,
        "plan_crew_name": planCrewName,
        "user_id": userId,
        "payment_status": paymentStatus,
        "plan_duration": planDuration,
        "plan_start_date": planStartDate == null ? null : planStartDate,
        "plan_expiry_date": planExpiryDate == null ? null : planExpiryDate,
        "plan_amount": planAmount,
        "is_active": isActive,
        "updated_at": updatedAt,
      };
}
