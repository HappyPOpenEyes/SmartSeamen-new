// To parse this JSON data, do
//
//     final userLimitResponse = userLimitResponseFromJson(jsonString);

import 'dart:convert';

UserLimitResponse userLimitResponseFromJson(String str) =>
    UserLimitResponse.fromJson(json.decode(str));

String userLimitResponseToJson(UserLimitResponse data) =>
    json.encode(data.toJson());

class UserLimitResponse {
  UserLimitResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory UserLimitResponse.fromJson(Map<String, dynamic> json) =>
      UserLimitResponse(
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
    required this.user,
    required this.payment,
    required this.isUserRecoveryQuestion,
  });

  List<User> user;
  Payment? payment;
  int isUserRecoveryQuestion;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
      payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      isUserRecoveryQuestion: json["Userrecoveryquestion"]);

  Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
        "payment": payment!.toJson(),
        "Userrecoveryquestion": isUserRecoveryQuestion
      };
}

class Payment {
  Payment({
    required this.id,
    required this.planId,
    required this.userId,
    required this.paymentId,
    this.companyId,
    required this.planExpiryDate,
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
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String planId;
  String userId;
  String paymentId;
  dynamic companyId;
  DateTime planExpiryDate;
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
  DateTime createdAt;
  DateTime updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        planId: json["plan_id"],
        userId: json["user_id"],
        paymentId: json["payment_id"],
        companyId: json["company_id"],
        planExpiryDate: DateTime.parse(json["plan_expiry_date"]),
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_id": planId,
        "user_id": userId,
        "payment_id": paymentId,
        "company_id": companyId,
        "plan_expiry_date":
            "${planExpiryDate.year.toString().padLeft(4, '0')}-${planExpiryDate.month.toString().padLeft(2, '0')}-${planExpiryDate.day.toString().padLeft(2, '0')}",
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  User({
    required this.id,
    required this.roleId,
    required this.firstname,
    required this.lastname,
    required this.mobile,
    required this.lastLoginDate,
    this.photo,
    required this.email,
    required this.rankName,
  });

  String id;
  int roleId;
  String firstname;
  String lastname;
  int mobile;
  DateTime lastLoginDate;
  dynamic photo;
  String email;
  String? rankName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["role_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        mobile: json["mobile"],
        lastLoginDate: DateTime.parse(json["last_login_date"]),
        photo: json["photo"],
        email: json["email"],
        rankName: json["rank_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "firstname": firstname,
        "lastname": lastname,
        "mobile": mobile,
        "last_login_date": lastLoginDate.toIso8601String(),
        "photo": photo,
        "email": email,
        "rank_name": rankName,
      };
}
