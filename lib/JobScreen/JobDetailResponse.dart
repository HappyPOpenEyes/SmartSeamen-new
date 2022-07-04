// To parse this JSON data, do
//
//     final jobDetailResponse = jobDetailResponseFromJson(jsonString);

import 'dart:convert';

JobDetailResponse jobDetailResponseFromJson(String str) =>
    JobDetailResponse.fromJson(json.decode(str));

String jobDetailResponseToJson(JobDetailResponse data) =>
    json.encode(data.toJson());

class JobDetailResponse {
  JobDetailResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  List<Datum> data;

  factory JobDetailResponse.fromJson(Map<String, dynamic> json) =>
      JobDetailResponse(
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
    required this.companyName,
    required this.companyId,
    required this.companyLogo,
    this.companyLicense,
    required this.vesselType,
    required this.vesselName,
    required this.tentativeJoiningDate,
    required this.exptirationDate,
    required this.preferredNationality,
    required this.nationalityName,
    required this.status,
    required this.apply,
    required this.description,
    required this.publishDate,
    required this.isActive,
    required this.getrankdetail1,
    required this.getrankdetail,
  });

  String id;
  String companyName;
  String companyId;
  dynamic companyLogo;
  dynamic companyLicense;
  List<String> vesselType;
  List<String> vesselName;
  String tentativeJoiningDate;
  String exptirationDate;
  List<String> preferredNationality;
  String nationalityName;
  int status;
  int apply;
  String description;
  DateTime? publishDate;
  int isActive;
  List<Getrankdetail> getrankdetail1;
  List<Getrankdetail> getrankdetail;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        companyId: json["company_id"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"],
        companyLicense: json["company_license"],
        vesselType: List<String>.from(json["Vessel_Type"].map((x) => x)),
        vesselName: List<String>.from(json["vessel_name"].map((x) => x)),
        tentativeJoiningDate: json["Tentative_Joining_date"],
        exptirationDate: json["Exptiration_date"],
        preferredNationality:
            List<String>.from(json["Preferred_Nationality"].map((x) => x)),
        nationalityName: json["Nationality_name"],
        status: json["status"],
        apply: json["apply"],
        description: json["Description"],
        publishDate: json["publish_date"] == null
            ? null
            : DateTime.parse(json["publish_date"]),
        isActive: json["is_active"],
        getrankdetail1: List<Getrankdetail>.from(
            json["getrankdetail1"].map((x) => Getrankdetail.fromJson(x))),
        getrankdetail: List<Getrankdetail>.from(
            json["getrankdetail"].map((x) => Getrankdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "company_name": companyName,
        "company_logo": companyLogo,
        "company_license": companyLicense,
        "Vessel_Type": List<dynamic>.from(vesselType.map((x) => x)),
        "vessel_name": List<dynamic>.from(vesselName.map((x) => x)),
        "Tentative_Joining_date": tentativeJoiningDate,
        "Exptiration_date": exptirationDate,
        "Preferred_Nationality":
            List<dynamic>.from(preferredNationality.map((x) => x)),
        "Nationality_name": nationalityName,
        "status": status,
        "Description": description,
        "publish_date":
            "${publishDate!.year.toString().padLeft(4, '0')}-${publishDate!.month.toString().padLeft(2, '0')}-${publishDate!.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "getrankdetail1":
            List<dynamic>.from(getrankdetail1.map((x) => x.toJson())),
        "getrankdetail":
            List<dynamic>.from(getrankdetail.map((x) => x.toJson())),
      };
}

class Getrankdetail {
  Getrankdetail({
    required this.id,
    required this.jobRequirementId,
    required this.rankId,
    required this.noofPositions,
    required this.experience,
    required this.number,
    required this.cocIssuing,
    required this.isActive,
    required this.rank,
    required this.cocIssuingCountry,
    required this.createdAt,
  });

  String id;
  String jobRequirementId;
  String rankId;
  int noofPositions;
  int experience;
  int number;
  List<CocIssuing> cocIssuing;
  int isActive;
  String rank;
  List<String> cocIssuingCountry;
  DateTime createdAt;

  factory Getrankdetail.fromJson(Map<String, dynamic> json) => Getrankdetail(
        id: json["id"],
        jobRequirementId: json["job_requirement_id"],
        rankId: json["rank_id"],
        noofPositions: json["NoofPositions"],
        experience: json["Experience"],
        number: json["number"],
        cocIssuing: List<CocIssuing>.from(
            json["coc_issuing"].map((x) => CocIssuing.fromJson(x))),
        isActive: json["is_active"],
        rank: json["rank"],
        cocIssuingCountry:
            List<String>.from(json["coc_issuing_country"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_requirement_id": jobRequirementId,
        "rank_id": rankId,
        "NoofPositions": noofPositions,
        "Experience": experience,
        "number": number,
        "coc_issuing": List<dynamic>.from(cocIssuing.map((x) => x.toJson())),
        "is_active": isActive,
        "rank": rank,
        "coc_issuing_country":
            List<dynamic>.from(cocIssuingCountry.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
      };
}

class CocIssuing {
  CocIssuing({
    required this.id,
    required this.issueName,
  });

  String id;
  String issueName;

  factory CocIssuing.fromJson(Map<String, dynamic> json) => CocIssuing(
        id: json["id"],
        issueName: json["issue_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "issue_name": issueName,
      };
}
