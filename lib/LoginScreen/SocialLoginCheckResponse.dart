// To parse this JSON data, do
//
//     final socialLoginCheckResponse = socialLoginCheckResponseFromJson(jsonString);

import 'dart:convert';

SocialLoginCheckResponse socialLoginCheckResponseFromJson(String str) => SocialLoginCheckResponse.fromJson(json.decode(str));

String socialLoginCheckResponseToJson(SocialLoginCheckResponse data) => json.encode(data.toJson());

class SocialLoginCheckResponse {
    SocialLoginCheckResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    Data data;

    factory SocialLoginCheckResponse.fromJson(Map<String, dynamic> json) => SocialLoginCheckResponse(
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
        required this.accessToken,
        required this.token,
    });

    String accessToken;
    Token token;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        token: Token.fromJson(json["token"]),
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "token": token.toJson(),
    };
}

class Token {
    Token({
        required this.id,
        required this.userId,
        required this.clientId,
        required this.name,
        required this.scopes,
        required this.revoked,
        required this.createdAt,
        required this.updatedAt,
        required this.expiresAt,
    });

    String id;
    String userId;
    int clientId;
    String name;
    List<dynamic> scopes;
    bool revoked;
    DateTime createdAt;
    DateTime updatedAt;
    DateTime expiresAt;

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: json["id"],
        userId: json["user_id"],
        clientId: json["client_id"],
        name: json["name"],
        scopes: List<dynamic>.from(json["scopes"].map((x) => x)),
        revoked: json["revoked"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        expiresAt: DateTime.parse(json["expires_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "client_id": clientId,
        "name": name,
        "scopes": List<dynamic>.from(scopes.map((x) => x)),
        "revoked": revoked,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "expires_at": expiresAt.toIso8601String(),
    };
}
