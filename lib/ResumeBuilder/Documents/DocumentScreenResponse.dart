// To parse this JSON data, do
//
//     final getDocumentResponse = getDocumentResponseFromJson(jsonString);

import 'dart:convert';

GetDocumentResponse getDocumentResponseFromJson(String str) =>
    GetDocumentResponse.fromJson(json.decode(str));

String getDocumentResponseToJson(GetDocumentResponse data) =>
    json.encode(data.toJson());

class GetDocumentResponse {
  GetDocumentResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory GetDocumentResponse.fromJson(Map<String, dynamic> json) =>
      GetDocumentResponse(
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
    required this.cdcDetails,
    required this.passportDetails,
    required this.visaDetails,
    required this.visacountry,
    required this.travelconfigid,
    required this.visaconfigid,
    required this.competancy,
    required this.optionalDoc,
    required this.medical,
    required this.stcwmandate,
    required this.stcwoptional,
    required this.mandateoptional,
    required this.stcwmandateoptional,
  });

  List<Detail> cdcDetails;
  List<Detail> passportDetails;
  List<VisaDetail> visaDetails;
  List<Visacountry> visacountry;
  List<Configid> travelconfigid;
  List<Configid> visaconfigid;
  List<Competancy> competancy;
  List<Competancy> optionalDoc;
  List<Medical> medical;
  List<Stcw> stcwmandate;
  List<Stcw> stcwoptional;
  Mandateoptional mandateoptional;
  Stcwmandateoptional stcwmandateoptional;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cdcDetails: List<Detail>.from(
            json["cdcDetails"].map((x) => Detail.fromJson(x))),
        passportDetails: List<Detail>.from(
            json["passportDetails"].map((x) => Detail.fromJson(x))),
        visaDetails: List<VisaDetail>.from(
            json["visaDetails"].map((x) => VisaDetail.fromJson(x))),
        visacountry: List<Visacountry>.from(
            json["visacountry"].map((x) => Visacountry.fromJson(x))),
        travelconfigid: List<Configid>.from(
            json["travelconfigid"].map((x) => Configid.fromJson(x))),
        visaconfigid: List<Configid>.from(
            json["visaconfigid"].map((x) => Configid.fromJson(x))),
        competancy: List<Competancy>.from(
            json["competancy"].map((x) => Competancy.fromJson(x))),
        optionalDoc: List<Competancy>.from(
            json["optionalDoc"].map((x) => Competancy.fromJson(x))),
        medical:
            List<Medical>.from(json["medical"].map((x) => Medical.fromJson(x))),
        stcwmandate:
            List<Stcw>.from(json["stcwmandate"].map((x) => Stcw.fromJson(x))),
        stcwoptional:
            List<Stcw>.from(json["stcwoptional"].map((x) => Stcw.fromJson(x))),
        mandateoptional: Mandateoptional.fromJson(json["mandateoptional"]),
        stcwmandateoptional:
            Stcwmandateoptional.fromJson(json["stcwmandateoptional"]),
      );

  Map<String, dynamic> toJson() => {
        "cdcDetails": List<dynamic>.from(cdcDetails.map((x) => x.toJson())),
        "passportDetails":
            List<dynamic>.from(passportDetails.map((x) => x.toJson())),
        "visaDetails": List<dynamic>.from(visaDetails.map((x) => x.toJson())),
        "visacountry": List<dynamic>.from(visacountry.map((x) => x.toJson())),
        "travelconfigid":
            List<dynamic>.from(travelconfigid.map((x) => x.toJson())),
        "visaconfigid": List<dynamic>.from(visaconfigid.map((x) => x.toJson())),
        "competancy": List<dynamic>.from(competancy.map((x) => x.toJson())),
        "optionalDoc": List<dynamic>.from(optionalDoc.map((x) => x.toJson())),
        "medical": List<dynamic>.from(medical.map((x) => x.toJson())),
        "stcwmandate": List<dynamic>.from(stcwmandate.map((x) => x.toJson())),
        "stcwoptional": List<dynamic>.from(stcwoptional.map((x) => x.toJson())),
        "mandateoptional": mandateoptional.toJson(),
        "stcwmandateoptional": stcwmandateoptional.toJson(),
      };
}

class Detail {
  Detail({
    required this.id,
    required this.userId,
    required this.configrationId,
    required this.documentNo,
    required this.placeOfIssue,
    required this.issueDate,
    required this.validTillDate,
    required this.issuingAuthorityId,
    required this.validTillType,
    required this.validTillTypeName,
    required this.issuingAuthorityName,
  });

  String id;
  String userId;
  int configrationId;
  String documentNo;
  String? placeOfIssue;
  String issueDate;
  String? validTillDate;
  String? issuingAuthorityId;
  String validTillType;
  String validTillTypeName;
  String issuingAuthorityName;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        userId: json["user_id"],
        configrationId: json["configration_id"],
        documentNo: json["document_no"],
        placeOfIssue:
            json["place_of_issue"] == null ? null : json["place_of_issue"],
        issueDate: json["issue_date"],
        validTillDate:
            json["valid_till_date"] == null ? null : json["valid_till_date"],
        issuingAuthorityId: json["issuing_authority_id"] == null
            ? null
            : json["issuing_authority_id"],
        validTillType: json["valid_till_type"],
        validTillTypeName: json["valid_till_type_name"],
        issuingAuthorityName: json["issuing_authority_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "configration_id": configrationId,
        "document_no": documentNo,
        "place_of_issue": placeOfIssue == null ? null : placeOfIssue,
        "issue_date": issueDate,
        "valid_till_date": validTillDate,
        "issuing_authority_id":
            issuingAuthorityId == null ? null : issuingAuthorityId,
        "valid_till_type": validTillType,
        "valid_till_type_name": validTillTypeName,
        "issuing_authority_name": issuingAuthorityName,
      };
}

class Competancy {
  Competancy({
    required this.userId,
    required this.documentTypeId,
    required this.documentApplicable,
    required this.displayText,
    required this.id,
    required this.certificateNo,
    required this.hasDocument,
    required this.issuingAuthorityId,
    required this.issueName,
    this.issueDate,
    this.validTillDate,
    required this.validTillType,
    required this.rankDocumentId,
  });

  String userId;
  int documentTypeId;
  int documentApplicable;
  String displayText;
  String id;
  String certificateNo;
  int hasDocument;
  String issuingAuthorityId;
  String issueName;
  dynamic issueDate;
  dynamic validTillDate;
  int validTillType;
  String rankDocumentId;

  factory Competancy.fromJson(Map<String, dynamic> json) => Competancy(
        userId: json["user_id"],
        documentTypeId: json["document_type_id"],
        documentApplicable: json["document_applicable"],
        displayText: json["display_text"],
        id: json["id"],
        certificateNo: json["certificate_no"],
        hasDocument: json["has_document"],
        issuingAuthorityId: json["issuing_authority_id"],
        issueName: json["issue_name"],
        issueDate: json["issue_date"],
        validTillDate: json["valid_till_date"],
        validTillType: json["valid_till_type"],
        rankDocumentId: json["rank_document_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "document_type_id": documentTypeId,
        "document_applicable": documentApplicable,
        "display_text": displayText,
        "id": id,
        "certificate_no": certificateNo,
        "has_document": hasDocument,
        "issuing_authority_id": issuingAuthorityId,
        "issue_name": issueName,
        "issue_date": issueDate,
        "valid_till_date": validTillDate,
        "valid_till_type": validTillType,
        "rank_document_id": rankDocumentId,
      };
}

class Mandateoptional {
  Mandateoptional({
    required this.mandate,
    required this.optional,
  });

  List<MandateoptionalMandate> mandate;
  List<MandateoptionalMandate> optional;

  factory Mandateoptional.fromJson(Map<String, dynamic> json) =>
      Mandateoptional(
        mandate: List<MandateoptionalMandate>.from(
            json["mandate"].map((x) => MandateoptionalMandate.fromJson(x))),
        optional: List<MandateoptionalMandate>.from(
            json["optional"].map((x) => MandateoptionalMandate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mandate": List<dynamic>.from(mandate.map((x) => x.toJson())),
        "optional": List<dynamic>.from(optional.map((x) => x.toJson())),
      };
}

class MandateoptionalMandate {
  MandateoptionalMandate({
    required this.id,
    required this.documentTypeId,
    required this.documentApplicable,
    required this.displayText,
  });

  String id;
  int documentTypeId;
  int documentApplicable;
  String displayText;

  factory MandateoptionalMandate.fromJson(Map<String, dynamic> json) =>
      MandateoptionalMandate(
        id: json["id"],
        documentTypeId: json["document_type_id"],
        documentApplicable: json["document_applicable"],
        displayText: json["display_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document_type_id": documentTypeId,
        "document_applicable": documentApplicable,
        "display_text": displayText,
      };
}

class Medical {
  Medical({
    required this.medicalDocumentId,
    required this.medicalName,
    required this.id,
    required this.userId,
    required this.medicalDocumentName,
    required this.hasDocument,
    required this.isActive,
  });

  String medicalDocumentId;
  String medicalName;
  String? id;
  String? userId;
  String? medicalDocumentName;
  String? hasDocument;
  int? isActive;

  factory Medical.fromJson(Map<String, dynamic> json) => Medical(
        medicalDocumentId: json["medical_document_id"],
        medicalName: json["medical_name"],
        id: json["id"],
        userId: json["user_id"],
        medicalDocumentName: json["medical_document_name"],
        hasDocument: json["has_document"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "medical_document_id": medicalDocumentId,
        "medical_name": medicalName,
        "id": id,
        "user_id": userId,
        "medical_document_name": medicalDocumentName,
        "has_document": hasDocument,
        "is_active": isActive,
      };
}

class Stcw {
  Stcw({
    required this.id,
    required this.stcwName,
    required this.userId,
    required this.documentId,
    required this.documentType,
    required this.certificateNo,
    required this.validDate,
    this.issueDate,
    required this.validTillType,
  });

  String id;
  String stcwName;
  String userId;
  String documentId;
  int documentType;
  String? certificateNo;
  DateTime? validDate;
  dynamic issueDate;
  int validTillType;

  factory Stcw.fromJson(Map<String, dynamic> json) => Stcw(
        id: json["id"],
        stcwName: json["stcw_name"],
        userId: json["user_id"],
        documentId: json["document_id"],
        documentType: json["document_type"],
        certificateNo:
            json["certificate_no"] == null ? null : json["certificate_no"],
        validDate: json["valid_date"] == null
            ? null
            : DateTime.parse(json["valid_date"]),
        issueDate: json["issue_date"],
        validTillType: json["valid_till_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stcw_name": stcwName,
        "user_id": userId,
        "document_id": documentId,
        "document_type": documentType,
        "certificate_no": certificateNo == null ? null : certificateNo,
        "valid_date":
            "${validDate!.year.toString().padLeft(4, '0')}-${validDate!.month.toString().padLeft(2, '0')}-${validDate!.day.toString().padLeft(2, '0')}",
        "issue_date": issueDate,
        "valid_till_type": validTillType,
      };
}

class Stcwmandateoptional {
  Stcwmandateoptional({
    required this.mandate,
    required this.optional,
  });

  List<StcwmandateoptionalMandate> mandate;
  List<StcwmandateoptionalMandate> optional;

  factory Stcwmandateoptional.fromJson(Map<String, dynamic> json) =>
      Stcwmandateoptional(
        mandate: List<StcwmandateoptionalMandate>.from(
            json["mandate"].map((x) => StcwmandateoptionalMandate.fromJson(x))),
        optional: List<StcwmandateoptionalMandate>.from(json["optional"]
            .map((x) => StcwmandateoptionalMandate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mandate": List<dynamic>.from(mandate.map((x) => x.toJson())),
        "optional": List<dynamic>.from(optional.map((x) => x.toJson())),
      };
}

class StcwmandateoptionalMandate {
  StcwmandateoptionalMandate({
    required this.id,
    required this.stcwName,
    required this.documentType,
    required this.isSystemGenerated,
    required this.isApproved,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String stcwName;
  int documentType;
  int isSystemGenerated;
  int isApproved;
  int isActive;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory StcwmandateoptionalMandate.fromJson(Map<String, dynamic> json) =>
      StcwmandateoptionalMandate(
        id: json["id"],
        stcwName: json["stcw_name"],
        documentType: json["document_type"],
        isSystemGenerated: json["is_system_generated"],
        isApproved: json["is_approved"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stcw_name": stcwName,
        "document_type": documentType,
        "is_system_generated": isSystemGenerated,
        "is_approved": isApproved,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Configid {
  Configid({
    required this.id,
    required this.key,
    required this.value,
    required this.displayText,
    this.description,
    this.displayOrder,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String key;
  String value;
  String displayText;
  dynamic description;
  dynamic displayOrder;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;

  factory Configid.fromJson(Map<String, dynamic> json) => Configid(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        displayText: json["display_text"],
        description: json["description"],
        displayOrder: json["display_order"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "display_text": displayText,
        "description": description,
        "display_order": displayOrder,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class VisaDetail {
  VisaDetail({
    required this.id,
    required this.userId,
    required this.configrationId,
    required this.configrationName,
    this.countryId,
    this.countryName,
    required this.hasDocument,
    this.documentNo,
    this.placeOfIssue,
    this.issueDate,
    this.validTillDate,
    this.issuingAuthorityId,
    required this.validTillType,
    required this.validTillTypeName,
    this.issuingAuthorityName,
  });

  String id;
  String userId;
  int configrationId;
  String configrationName;
  dynamic countryId;
  dynamic countryName;
  int hasDocument;
  dynamic documentNo;
  dynamic placeOfIssue;
  dynamic issueDate;
  dynamic validTillDate;
  dynamic issuingAuthorityId;
  String validTillType;
  String validTillTypeName;
  dynamic issuingAuthorityName;

  factory VisaDetail.fromJson(Map<String, dynamic> json) => VisaDetail(
        id: json["id"],
        userId: json["user_id"],
        configrationId: json["configration_id"],
        configrationName: json["configration_name"],
        countryId: json["country_id"],
        countryName: json["country_name"],
        hasDocument: json["has_document"],
        documentNo: json["document_no"],
        placeOfIssue: json["place_of_issue"],
        issueDate: json["issue_date"],
        validTillDate: json["valid_till_date"],
        issuingAuthorityId: json["issuing_authority_id"],
        validTillType: json["valid_till_type"],
        validTillTypeName: json["valid_till_type_name"],
        issuingAuthorityName: json["issuing_authority_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "configration_id": configrationId,
        "configration_name": configrationName,
        "country_id": countryId,
        "country_name": countryName,
        "has_document": hasDocument,
        "document_no": documentNo,
        "place_of_issue": placeOfIssue,
        "issue_date": issueDate,
        "valid_till_date": validTillDate,
        "issuing_authority_id": issuingAuthorityId,
        "valid_till_type": validTillType,
        "valid_till_type_name": validTillTypeName,
        "issuing_authority_name": issuingAuthorityName,
      };
}

class Visacountry {
  Visacountry({
    required this.id,
    required this.countryName,
  });

  int id;
  String countryName;

  factory Visacountry.fromJson(Map<String, dynamic> json) => Visacountry(
        id: json["id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
      };
}
