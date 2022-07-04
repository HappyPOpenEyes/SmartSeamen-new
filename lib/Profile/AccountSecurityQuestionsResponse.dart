// To parse this JSON data, do
//
//     final accountSecurityQuestionsResponse = accountSecurityQuestionsResponseFromJson(jsonString);

import 'dart:convert';

AccountSecurityQuestionsResponse accountSecurityQuestionsResponseFromJson(
        String str) =>
    AccountSecurityQuestionsResponse.fromJson(json.decode(str));

String accountSecurityQuestionsResponseToJson(
        AccountSecurityQuestionsResponse data) =>
    json.encode(data.toJson());

class AccountSecurityQuestionsResponse {
  AccountSecurityQuestionsResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory AccountSecurityQuestionsResponse.fromJson(
          Map<String, dynamic> json) =>
      AccountSecurityQuestionsResponse(
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
    required this.photo,
    required this.firstname,
    required this.lastname,
    required this.countryId,
    required this.mobile,
    required this.email,
    required this.otp,
    required this.mobileOtp,
    required this.alternateEmail,
    required this.getuser,
    required this.getSocialfacebook,
    required this.getSociallinkdin,
    required this.getSocialgoogle,
    required this.getSocialtwitter,
    required this.getSocialapple,
    required this.payment,
  });

  String id;
  dynamic photo;
  String firstname;
  String lastname;
  int countryId;
  int mobile;
  String email;
  dynamic otp;
  dynamic mobileOtp;
  String? alternateEmail;
  List<Getuser> getuser;
  List<GetSocial> getSocialfacebook;
  List<GetSocial> getSociallinkdin;
  List<GetSocial> getSocialgoogle;
  List<GetSocial> getSocialtwitter;
  List<GetSocial> getSocialapple;
  Payment? payment;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        photo: json["photo"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        countryId: json["country_id"],
        mobile: json["mobile"],
        email: json["email"],
        otp: json["otp"],
        mobileOtp: json["mobile_otp"],
        alternateEmail: json["alternate_email"],
        getuser:
            List<Getuser>.from(json["getuser"].map((x) => Getuser.fromJson(x))),
        getSocialfacebook: List<GetSocial>.from(
            json["getSocialfacebook"].map((x) => GetSocial.fromJson(x))),
        getSociallinkdin: List<GetSocial>.from(
            json["getSociallinkdin"].map((x) => GetSocial.fromJson(x))),
        getSocialgoogle: List<GetSocial>.from(
            json["getSocialgoogle"].map((x) => GetSocial.fromJson(x))),
        getSocialtwitter: List<GetSocial>.from(
            json["getSocialtwitter"].map((x) => GetSocial.fromJson(x))),
        getSocialapple: List<GetSocial>.from(
            json["getSocialApple"].map((x) => GetSocial.fromJson(x))),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "firstname": firstname,
        "lastname": lastname,
        "country_id": countryId,
        "mobile": mobile,
        "email": email,
        "otp": otp,
        "mobile_otp": mobileOtp,
        "alternate_email": alternateEmail,
        "getuser": List<dynamic>.from(getuser.map((x) => x.toJson())),
        "getSocialfacebook":
            List<dynamic>.from(getSocialfacebook.map((x) => x.toJson())),
        "getSociallinkdin":
            List<dynamic>.from(getSociallinkdin.map((x) => x.toJson())),
        "getSocialgoogle": List<dynamic>.from(getSocialgoogle.map((x) => x)),
        "getSocialtwitter": List<dynamic>.from(getSocialtwitter.map((x) => x)),
        "getSocialApple": List<dynamic>.from(getSocialtwitter.map((x) => x)),
        "payment": payment!.toJson(),
      };
}

class GetSocial {
  GetSocial({
    required this.id,
    required this.userId,
    required this.providerName,
    required this.providerId,
  });

  int id;
  String userId;
  String providerName;
  String providerId;

  factory GetSocial.fromJson(Map<String, dynamic> json) => GetSocial(
        id: json["id"],
        userId: json["user_id"],
        providerName: json["provider_name"],
        providerId: json["provider_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "provider_name": providerName,
        "provider_id": providerId,
      };
}

class Getuser {
  Getuser({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.question,
    required this.answer,
  });

  int id;
  String userId;
  int questionId;
  String question;
  String answer;

  factory Getuser.fromJson(Map<String, dynamic> json) => Getuser(
        id: json["id"],
        userId: json["user_id"],
        questionId: json["question_id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "question_id": questionId,
        "question": question,
        "answer": answer,
      };
}

class Payment {
  Payment({
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
  String? planExpiryDate;
  String? planExpiryDates;
  dynamic planAmount;
  int isActive;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        planCrewId: json["plan_crew_id"],
        planStartDate: json["plan_start_date"],
        planExpiryDate:
            json["plan_expiry_date"] == null ? null : json["plan_expiry_date"],
        planExpiryDates: json["plan_expiry_dates"] == null
            ? null
            : json["plan_expiry_dates"],
        planAmount: json["plan_amount"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_crew_id": planCrewId,
        "plan_start_date": planStartDate,
        "plan_expiry_date": planExpiryDate,
        "plan_expiry_dates": planExpiryDates,
        "plan_amount": planAmount,
        "is_active": isActive,
      };
}
