// To parse this JSON data, do
//
//     final allJobResponse = allJobResponseFromJson(jsonString);

import 'dart:convert';

AllJobResponse allJobResponseFromJson(String str) =>
    AllJobResponse.fromJson(json.decode(str));

String allJobResponseToJson(AllJobResponse data) => json.encode(data.toJson());

class AllJobResponse {
  AllJobResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  Data data;

  factory AllJobResponse.fromJson(Map<String, dynamic> json) => AllJobResponse(
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
    required this.jobs,
    required this.limit,
    required this.applyjobs,
    required this.userpublishstatus,
  });

  List<Job> jobs;
  Limit? limit;
  int applyjobs;
  int? userpublishstatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
        limit: json["limit"] == null ? null : Limit.fromJson(json["limit"]),
        applyjobs: json["applyjobs"],
        userpublishstatus: json["userpublishstatus"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
        "limit": limit!.toJson(),
        "applyjobs": applyjobs,
        "userpublishstatus": userpublishstatus,
      };
}

class Job {
  Job({
    required this.id,
    required this.referJobStatus,
    required this.updatedAt,
    required this.companyId,
    required this.vesselType,
    required this.tentaiveJoiningDate,
    required this.jobExpirationDate,
    required this.publishDate,
    required this.isUpdatedStatus,
    required this.companyName,
    required this.companyLogo,
    required this.rankId,
    required this.nationality,
    required this.rankName,
    required this.vesselName,
    required this.getrankdetail,
    required this.apply,
  });

  String id;
  int referJobStatus;
  DateTime updatedAt;
  String companyId;
  String vesselType;
  String tentaiveJoiningDate;
  String jobExpirationDate;
  String publishDate;
  int isUpdatedStatus;
  String companyName;
  String? companyLogo;
  String rankId;
  String nationality;
  String rankName;
  String vesselName;
  String getrankdetail;
  int apply;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        referJobStatus: json["refer_job_status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        companyId: json["company_id"],
        vesselType: json["vessel_type"],
        tentaiveJoiningDate: json["tentaive_joining_date"],
        jobExpirationDate: json["job_expiration_date"],
        publishDate: json["publish_date"],
        isUpdatedStatus: json["is_updated_status"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
        rankId: json["rank_id"],
        nationality: json["nationality"],
        rankName: json["rank_name"],
        vesselName: json["vessel_name"],
        getrankdetail: json["getrankdetail"],
        apply: json["apply"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refer_job_status": referJobStatus,
        "updated_at": updatedAt.toIso8601String(),
        "company_id": companyId,
        "vessel_type": vesselType,
        "tentaive_joining_date": tentaiveJoiningDate,
        "job_expiration_date": jobExpirationDate,
        "publish_date": publishDate,
        "is_updated_status": isUpdatedStatus,
        "company_name": companyName,
        "company_logo": companyLogo == null ? null : companyLogo,
        "rank_id": rankId,
        "nationality": nationality,
        "rank_name": rankName,
        "vessel_name": vesselName,
        "getrankdetail": getrankdetail,
        "apply": apply,
      };
}

class Limit {
  Limit({
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
    required this.planId,
    required this.paymentId,
    required this.createProfile,
    required this.downloadResume,
    required this.jobNotification,
    required this.emailSupport,
    required this.shortlistNotification,
    required this.jobApplicationPerDay,
    required this.profileViewNotification,
    required this.profileHighlightEmployer,
    required this.jobsViews,
    required this.companyProfile,
    required this.personalProfile,
    required this.customizedJobApplicationReceived,
    this.featuredJobPost,
    this.adminJobPostMonth,
    this.profileView,
    this.crewNotification,
    this.addtionalUser,
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
  String planId;
  String paymentId;
  int createProfile;
  int downloadResume;
  int jobNotification;
  int emailSupport;
  int shortlistNotification;
  int jobApplicationPerDay;
  int profileViewNotification;
  int profileHighlightEmployer;
  int jobsViews;
  int companyProfile;
  int personalProfile;
  int customizedJobApplicationReceived;
  dynamic featuredJobPost;
  dynamic adminJobPostMonth;
  dynamic profileView;
  dynamic crewNotification;
  dynamic addtionalUser;

  factory Limit.fromJson(Map<String, dynamic> json) => Limit(
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
        planId: json["plan_id"],
        paymentId: json["payment_id"],
        createProfile: json["create_profile"],
        downloadResume: json["download_resume"],
        jobNotification: json["job_notification"],
        emailSupport: json["email_support"],
        shortlistNotification: json["shortlist_notification"],
        jobApplicationPerDay: json["job_application_per_day"],
        profileViewNotification: json["profile_view_notification"],
        profileHighlightEmployer: json["profile_highlight_employer"],
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
        "plan_expiry_date":
            "${planExpiryDate!.year.toString().padLeft(4, '0')}-${planExpiryDate!.month.toString().padLeft(2, '0')}-${planExpiryDate!.day.toString().padLeft(2, '0')}",
        "plan_amount": planAmount,
        "payment_json_response": paymentJsonResponse,
        "message": message,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_free": isFree,
        "plan_id": planId,
        "payment_id": paymentId,
        "create_profile": createProfile,
        "download_resume": downloadResume,
        "job_notification": jobNotification,
        "email_support": emailSupport,
        "shortlist_notification": shortlistNotification,
        "job_application_per_day": jobApplicationPerDay,
        "profile_view_notification": profileViewNotification,
        "profile_highlight_employer": profileHighlightEmployer,
        "jobs_views": jobsViews,
        "company_profile": companyProfile,
        "personal_profile": personalProfile,
        "customized_job_application_received": customizedJobApplicationReceived,
        "featured_job_post": featuredJobPost,
        "admin_job_post_month": adminJobPostMonth,
        "profile_view": profileView,
        "crew_notification": crewNotification,
        "addtional_user": addtionalUser,
      };
}
