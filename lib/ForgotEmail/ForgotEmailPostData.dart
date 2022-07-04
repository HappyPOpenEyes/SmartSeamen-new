// To parse this JSON data, do
//
//     final forgotEmailPostData = forgotEmailPostDataFromJson(jsonString);

import 'dart:convert';

List<ForgotEmailPostData> forgotEmailPostDataFromJson(String str) => List<ForgotEmailPostData>.from(json.decode(str).map((x) => ForgotEmailPostData.fromJson(x)));

String forgotEmailPostDataToJson(List<ForgotEmailPostData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForgotEmailPostData {
    ForgotEmailPostData({
        required this.questionId,
        required this.answer,
    });

    String questionId;
    String answer;

    factory ForgotEmailPostData.fromJson(Map<String, dynamic> json) => ForgotEmailPostData(
        questionId: json["questionId"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "answer": answer,
    };
}
