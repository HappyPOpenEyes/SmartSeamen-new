// To parse this JSON data, do
//
//     final dashboardExpiredDataResponse = dashboardExpiredDataResponseFromJson(jsonString);

import 'dart:convert';

DashboardExpiredDataResponse dashboardExpiredDataResponseFromJson(String str) => DashboardExpiredDataResponse.fromJson(json.decode(str));

String dashboardExpiredDataResponseToJson(DashboardExpiredDataResponse data) => json.encode(data.toJson());

class DashboardExpiredDataResponse {
    DashboardExpiredDataResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory DashboardExpiredDataResponse.fromJson(Map<String, dynamic> json) => DashboardExpiredDataResponse(
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
        required this.userId,
        required this.documentName,
        required this.document,
        required this.documentType,
        required this.hasDocument,
        required this.certificateNo,
        required this.validTillDate,
        required this.validTillDates,
        required this.competancyDocumentId,
        required this.documentId,
    });

    String id;
    String userId;
    String? documentName;
    String document;
    int? documentType;
    int? hasDocument;
    String? certificateNo;
    String validTillDate;
    DateTime validTillDates;
    String? competancyDocumentId;
    String? documentId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        documentName: json["document_name"],
        document: json["document"],
        documentType: json["document_type"] == null ? null : json["document_type"],
        hasDocument: json["has_document"] == null ? null : json["has_document"],
        certificateNo: json["certificate_no"] == null ? null : json["certificate_no"],
        validTillDate: json["valid_till_date"],
        validTillDates: DateTime.parse(json["valid_till_dates"]),
        competancyDocumentId: json["competancy_document_id"] == null ? null : json["competancy_document_id"],
        documentId: json["document_id"] == null ? null : json["document_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "document_name": documentName,
        "document": documentValues.reverse[document],
        "document_type": documentType == null ? null : documentType,
        "has_document": hasDocument == null ? null : hasDocument,
        "certificate_no": certificateNo == null ? null : certificateNo,
        "valid_till_date": validTillDate,
        "valid_till_dates": "${validTillDates.year.toString().padLeft(4, '0')}-${validTillDates.month.toString().padLeft(2, '0')}-${validTillDates.day.toString().padLeft(2, '0')}",
        "competancy_document_id": competancyDocumentId == null ? null : competancyDocumentId,
        "document_id": documentId == null ? null : documentId,
    };
}

// ignore: constant_identifier_names
enum Document { TRAVEL_DOCUMENTS, COMPETANCY_DOCUEMENT, STCW_DOCUEMENT }

final documentValues = EnumValues({
    "Competancy Docuement": Document.COMPETANCY_DOCUEMENT,
    "Stcw Docuement": Document.STCW_DOCUEMENT,
    "Travel Documents": Document.TRAVEL_DOCUMENTS
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => MapEntry(v, k));
        }
        return reverseMap;
    }
}
