import 'dart:convert';

LinkedinData validateLinkedinFromJson(String str) =>
    LinkedinData.fromJson(json.decode(str));

String validateLinkedinToJson(LinkedinData data) => json.encode(data.toJson());

class LinkedinData {
  LinkedinData(
      {required this.userId,
      required this.email,
      required this.name,
      required this.token,
      required this.expiresIn});

  String userId;
  String email;
  String name;
  String token;
  int expiresIn;

  factory LinkedinData.fromJson(Map<String, dynamic> json) => LinkedinData(
      userId: json["user_id"],
      email: json["email"],
      name: json["name"],
      token: json["token"],
      expiresIn: json["expires_in"]);

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "name": name,
        "token": token,
        "expires_in": expiresIn
      };
}
