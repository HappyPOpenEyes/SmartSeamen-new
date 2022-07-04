// To parse this JSON data, do
//
//     final featureJobResponse = featureJobResponseFromJson(jsonString);

import 'dart:convert';

FeatureJobResponse featureJobResponseFromJson(String str) =>
    FeatureJobResponse.fromJson(json.decode(str));

String featureJobResponseToJson(FeatureJobResponse data) =>
    json.encode(data.toJson());

class FeatureJobResponse {
  FeatureJobResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  dynamic count;
  Data? data;

  factory FeatureJobResponse.fromJson(Map<String, dynamic> json) =>
      FeatureJobResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: json["data"].length == 0 ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    required this.featured,
    required this.applyjobs,
    required this.userpublishstatus,
  });

  List<Featured> featured;
  int applyjobs;
  int? userpublishstatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        featured: List<Featured>.from(
            json["featured"].map((x) => Featured.fromJson(x))),
        applyjobs: json["applyjobs"],
        userpublishstatus: json["userpublishstatus"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "featured": List<dynamic>.from(featured.map((x) => x.toJson())),
        "applyjobs": applyjobs,
        "userpublishstatus": userpublishstatus,
      };
}

class Featured {
  Featured({
    required this.referJobStatus,
    required this.id,
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

  int referJobStatus;
  String id;
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

  factory Featured.fromJson(Map<String, dynamic> json) => Featured(
        referJobStatus: json["refer_job_status"],
        id: json["id"],
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
        "refer_job_status": referJobStatus,
        "id": id,
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
