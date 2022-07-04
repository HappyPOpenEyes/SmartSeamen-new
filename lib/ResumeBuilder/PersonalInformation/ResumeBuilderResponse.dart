// To parse this JSON data, do
//
//     final resumeBuilderData = resumeBuilderDataFromJson(jsonString);

import 'dart:convert';

ResumeBuilderData resumeBuilderDataFromJson(String str) =>
    ResumeBuilderData.fromJson(json.decode(str));

String resumeBuilderDataToJson(ResumeBuilderData data) =>
    json.encode(data.toJson());

class ResumeBuilderData {
  ResumeBuilderData({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory ResumeBuilderData.fromJson(Map<String, dynamic> json) =>
      ResumeBuilderData(
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
    required this.id,
    required this.companyId,
    required this.roleId,
    required this.firstname,
    required this.lastname,
    required this.alternateCountryId,
    required this.countryId,
    required this.mobile,
    this.alternateMobileNo,
    required this.email,
    required this.password,
    required this.lastLoginDate,
    required this.statusOnBoard,
    this.alternateEmail,
    this.dob,
    required this.photo,
    this.otp,
    this.alternateEmailOtp,
    required this.mobileOtp,
    required this.isVerified,
    required this.isActive,
    this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.resume,
    this.getuseraddress,
  });

  String id;
  dynamic companyId;
  int roleId;
  String firstname;
  String lastname;
  dynamic alternateCountryId;
  int countryId;
  int mobile;
  dynamic alternateMobileNo;
  String email;
  String? password;
  DateTime lastLoginDate;
  int statusOnBoard;
  dynamic alternateEmail;
  DateTime? dob;
  String? photo;
  dynamic otp;
  dynamic alternateEmailOtp;
  dynamic mobileOtp;
  int isVerified;
  int isActive;
  dynamic createdBy;
  String? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  Resume? resume;
  Getuseraddress? getuseraddress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        companyId: json["company_id"],
        roleId: json["role_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        alternateCountryId: json["alternate_country_id"] == null
            ? ""
            : json["alternate_country_id"],
        countryId: json["country_id"],
        mobile: json["mobile"],
        alternateMobileNo: json["alternate_mobile_no"],
        email: json["email"],
        password: json["password"],
        lastLoginDate: DateTime.parse(json["last_login_date"]),
        statusOnBoard: json["status_on_board"],
        alternateEmail: json["alternate_email"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        photo: json["photo"] == null ? null : json["photo"],
        otp: json["otp"],
        alternateEmailOtp: json["alternate_email_otp"],
        mobileOtp: json["mobile_otp"],
        isVerified: json["is_verified"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        resume: json["resume"] == null ? null : Resume.fromJson(json["resume"]),
        getuseraddress: json["Getuseraddress"] == null
            ? null
            : Getuseraddress.fromJson(json["Getuseraddress"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "role_id": roleId,
        "firstname": firstname,
        "lastname": lastname,
        "country_id": countryId,
        "mobile": mobile,
        "alternate_country_id": alternateCountryId,
        "alternate_mobile_no": alternateMobileNo,
        "email": email,
        "password": password,
        "last_login_date": lastLoginDate.toIso8601String(),
        "status_on_board": statusOnBoard,
        "alternate_email": alternateEmail,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "photo": photo,
        "otp": otp,
        "alternate_email_otp": alternateEmailOtp,
        "mobile_otp": mobileOtp,
        "is_verified": isVerified,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "resume": resume!.toJson(),
        "Getuseraddress": getuseraddress!.toJson(),
      };
}

class Getuseraddress {
  Getuseraddress({
    required this.id,
    required this.userId,
    required this.address1,
    required this.address2,
    required this.landmark,
    required this.countryId,
    required this.countryName,
    required this.pincode,
    required this.city,
    required this.state,
    this.isCommunicationAddress,
    this.comAddress1,
    this.comAddress2,
    this.comLandmark,
    this.comCountryId,
    required this.comCountryName,
    this.comPincode,
    this.comState,
    this.comCity,
  });

  String id;
  String userId;
  String address1;
  dynamic address2;
  String landmark;
  int countryId;
  String countryName;
  int pincode;
  String city;
  String state;
  dynamic isCommunicationAddress;
  dynamic comAddress1;
  dynamic comAddress2;
  dynamic comLandmark;
  dynamic comCountryId;
  dynamic comCountryName;
  dynamic comPincode;
  dynamic comState;
  dynamic comCity;

  factory Getuseraddress.fromJson(Map<String, dynamic> json) => Getuseraddress(
        id: json["id"],
        userId: json["user_id"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        countryId: json["country_id"],
        countryName: json["country_name"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        isCommunicationAddress: json["is_communication_address"],
        comAddress1: json["com_address1"],
        comAddress2: json["com_address2"],
        comLandmark: json["com_landmark"],
        comCountryId: json["com_country_id"],
        comCountryName: json["com_country_name"],
        comPincode: json["com_pincode"],
        comState: json["com_state"],
        comCity: json["com_city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "country_id": countryId,
        "country_name": countryName,
        "pincode": pincode,
        "city": city,
        "state": state,
        "is_communication_address": isCommunicationAddress,
        "com_address1": comAddress1,
        "com_address2": comAddress2,
        "com_landmark": comLandmark,
        "com_country_id": comCountryId,
        "com_country_name": comCountryName,
        "com_pincode": comPincode,
        "com_state": comState,
        "com_city": comCity,
      };
}

class Resume {
  Resume(
      {required this.id,
      required this.userId,
      required this.rankId,
      required this.subRankId,
      required this.lookingForPromotion,
      required this.vesselPreference,
      required this.vesselName,
      required this.nationality,
      required this.tentativeDate,
      required this.nationalityName,
      required this.indosNo,
      required this.getrankName,
      required this.subgetrankName,
      required this.createdAt,
      this.otherNationality,
      this.publishStatus});

  String id;
  String userId;
  String rankId;
  String? subRankId;
  int lookingForPromotion;
  List<String> vesselPreference;
  String vesselName;
  String nationality;
  DateTime tentativeDate;
  String nationalityName;
  String? indosNo;
  String getrankName;
  String? subgetrankName;
  String createdAt;
  dynamic otherNationality;
  dynamic publishStatus;

  factory Resume.fromJson(Map<String, dynamic> json) => Resume(
      id: json["id"],
      userId: json["user_id"],
      rankId: json["rank_id"],
      subRankId: json["sub_rank_id"],
      lookingForPromotion: json["looking_for_promotion"],
      vesselPreference:
          List<String>.from(json["vessel_preference"].map((x) => x)),
      vesselName: json["vessel_name"],
      nationality: json["nationality"],
      tentativeDate: DateTime.parse(json["tentative_date"]),
      nationalityName: json["nationality_name"],
      indosNo: json["indos_no"],
      getrankName: json["getrank_name"],
      subgetrankName: json["subgetrank_name"],
      createdAt: json["created_at"],
      otherNationality: json["other_nationality"],
      publishStatus: json["publish_status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "rank_id": rankId,
        "sub_rank_id": subRankId,
        "looking_for_promotion": lookingForPromotion,
        "vessel_preference": List<dynamic>.from(vesselPreference.map((x) => x)),
        "vessel_name": vesselName,
        "nationality": nationality,
        "tentative_date":
            "${tentativeDate.year.toString().padLeft(4, '0')}-${tentativeDate.month.toString().padLeft(2, '0')}-${tentativeDate.day.toString().padLeft(2, '0')}",
        "nationality_name": nationalityName,
        "indos_no": indosNo,
        "getrank_name": getrankName,
        "subgetrank_name": subgetrankName,
        "created_at": createdAt,
        "other_nationality": otherNationality,
        "publish_status": publishStatus
      };
}
