// To parse this JSON data, do
//
//     final getPaymentRedirectResponse = getPaymentRedirectResponseFromJson(jsonString);

import 'dart:convert';

GetPaymentRedirectResponse getPaymentRedirectResponseFromJson(String str) => GetPaymentRedirectResponse.fromJson(json.decode(str));

String getPaymentRedirectResponseToJson(GetPaymentRedirectResponse data) => json.encode(data.toJson());

class GetPaymentRedirectResponse {
    GetPaymentRedirectResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    Data data;

    factory GetPaymentRedirectResponse.fromJson(Map<String, dynamic> json) => GetPaymentRedirectResponse(
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
        required this.key,
        required this.salt,
        required this.txnid,
        required this.hash,
        required this.furl,
        required this.surl,
    });

    String key;
    String salt;
    String txnid;
    String hash;
    String furl;
    String surl;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        key: json["key"],
        salt: json["salt"],
        txnid: json["txnid"],
        hash: json["hash"],
        furl: json["furl"],
        surl: json["surl"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "salt": salt,
        "txnid": txnid,
        "hash": hash,
        "furl": furl,
        "surl": surl,
    };
}
