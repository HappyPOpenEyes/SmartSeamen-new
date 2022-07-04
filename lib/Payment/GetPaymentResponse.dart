// To parse this JSON data, do
//
//     final getPaymentResponse = getPaymentResponseFromJson(jsonString);

import 'dart:convert';

GetPaymentResponse getPaymentResponseFromJson(String str) =>
    GetPaymentResponse.fromJson(json.decode(str));

String getPaymentResponseToJson(GetPaymentResponse data) =>
    json.encode(data.toJson());

class GetPaymentResponse {
  GetPaymentResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory GetPaymentResponse.fromJson(Map<String, dynamic> json) =>
      GetPaymentResponse(
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
    required this.plans,
    required this.userCurrentPlanDetails,
  });

  List<Plan> plans;
  UserCurrentPlanDetails? userCurrentPlanDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
        userCurrentPlanDetails:
            UserCurrentPlanDetails.fromJson(json["userCurrentPlanDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
        "userCurrentPlanDetails": userCurrentPlanDetails!.toJson(),
      };
}

class Plan {
  Plan({
    required this.id,
    this.stripeProduct,
    this.stripePrice,
    required this.createProfile,
    required this.downloadResume,
    required this.jobNotification,
    required this.emailSupport,
    required this.shortlistNotification,
    required this.jobApplicationPerDay,
    required this.profileViewNotification,
    required this.profileHighlightEmployer,
    required this.planName,
    required this.planAmount,
    required this.planDuration,
    required this.jobsViews,
    required this.companyProfile,
    required this.personalProfile,
    required this.customizedJobApplicationReceived,
    this.featuredJobPost,
    required this.adminJobPostMonth,
    this.profileView,
    this.crewNotification,
    this.addtionalUser,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  dynamic stripeProduct;
  dynamic stripePrice;
  int createProfile;
  int downloadResume;
  int jobNotification;
  int emailSupport;
  int shortlistNotification;
  int jobApplicationPerDay;
  int profileViewNotification;
  int profileHighlightEmployer;
  String planName;
  String planAmount;
  int planDuration;
  int jobsViews;
  int companyProfile;
  int personalProfile;
  int customizedJobApplicationReceived;
  dynamic featuredJobPost;
  int adminJobPostMonth;
  dynamic profileView;
  dynamic crewNotification;
  dynamic addtionalUser;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        stripeProduct: json["stripe_product"],
        stripePrice: json["stripe_price"],
        createProfile: json["create_profile"],
        downloadResume: json["download_resume"],
        jobNotification: json["job_notification"],
        emailSupport: json["email_support"],
        shortlistNotification: json["shortlist_notification"],
        jobApplicationPerDay: json["job_application_per_day"],
        profileViewNotification: json["profile_view_notification"],
        profileHighlightEmployer: json["profile_highlight_employer"],
        planName: json["plan_name"],
        planAmount: json["plan_amount"],
        planDuration: json["plan_duration"],
        jobsViews: json["jobs_views"],
        companyProfile: json["company_profile"],
        personalProfile: json["personal_profile"],
        customizedJobApplicationReceived:
            json["customized_job_application_received"],
        featuredJobPost: json["featured_job_post"],
        adminJobPostMonth: json["admin_job_post_month"],
        profileView: json["profile_view"],
        crewNotification: json["crew_notification"],
        addtionalUser: json["addtional_user"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stripe_product": stripeProduct,
        "stripe_price": stripePrice,
        "create_profile": createProfile,
        "download_resume": downloadResume,
        "job_notification": jobNotification,
        "email_support": emailSupport,
        "shortlist_notification": shortlistNotification,
        "job_application_per_day": jobApplicationPerDay,
        "profile_view_notification": profileViewNotification,
        "profile_highlight_employer": profileHighlightEmployer,
        "plan_name": planName,
        "plan_amount": planAmount,
        "plan_duration": planDuration,
        "jobs_views": jobsViews,
        "company_profile": companyProfile,
        "personal_profile": personalProfile,
        "customized_job_application_received": customizedJobApplicationReceived,
        "featured_job_post": featuredJobPost,
        "admin_job_post_month": adminJobPostMonth,
        "profile_view": profileView,
        "crew_notification": crewNotification,
        "addtional_user": addtionalUser,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class UserCurrentPlanDetails {
  UserCurrentPlanDetails({
    required this.id,
    required this.userId,
    this.companyId,
    required this.planCrewId,
    required this.paymentMethod,
    required this.paymentIntentId,
    required this.paymentStatus,
    required this.planDuration,
    required this.planStartDate,
    required this.planExpiryDate,
    required this.planAmount,
    required this.paymentJsonResponse,
    this.message,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isFree,
  });

  String id;
  String userId;
  dynamic companyId;
  String planCrewId;
  String? paymentMethod;
  String? paymentIntentId;
  String paymentStatus;
  int planDuration;
  DateTime planStartDate;
  DateTime? planExpiryDate;
  String planAmount;
  String? paymentJsonResponse;
  dynamic message;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int isFree;

  factory UserCurrentPlanDetails.fromJson(Map<String, dynamic> json) =>
      UserCurrentPlanDetails(
        id: json["id"],
        userId: json["user_id"],
        companyId: json["company_id"],
        planCrewId: json["plan_crew_id"],
        paymentMethod: json["payment_method"] ?? '',
        paymentIntentId: json["payment_intent_id"] ?? '',
        paymentStatus: json["payment_status"],
        planDuration: json["plan_duration"],
        planStartDate: DateTime.parse(json["plan_start_date"]),
        planExpiryDate: json["plan_expiry_date"] == null
            ? null
            : DateTime.parse(json["plan_expiry_date"]),
        planAmount: json["plan_amount"],
        paymentJsonResponse: json["payment_json_response"] ?? '',
        message: json["message"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isFree: json["is_free"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_id": companyId,
        "plan_crew_id": planCrewId,
        "payment_method": paymentMethod,
        "payment_intent_id": paymentIntentId,
        "payment_status": paymentStatus,
        "plan_duration": planDuration,
        "plan_start_date": planStartDate.toIso8601String(),
        "plan_expiry_date": planExpiryDate!.toIso8601String(),
        "plan_amount": planAmount,
        "payment_json_response": paymentJsonResponse,
        "message": message,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_free": isFree,
      };
}
