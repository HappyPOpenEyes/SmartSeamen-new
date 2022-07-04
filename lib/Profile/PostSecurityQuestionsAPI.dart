// To parse this JSON data, do
//
//     final postSecurityQuestions = postSecurityQuestionsFromJson(jsonString);

import 'dart:convert';

PostSecurityQuestions postSecurityQuestionsFromJson(String str) => PostSecurityQuestions.fromJson(json.decode(str));

String postSecurityQuestionsToJson(PostSecurityQuestions data) => json.encode(data.toJson());

class PostSecurityQuestions {
    PostSecurityQuestions({
        required this.id,
        required this.questions,
    });

    String id;
    List<Question> questions;

    factory PostSecurityQuestions.fromJson(Map<String, dynamic> json) => PostSecurityQuestions(
        id: json["id"],
        questions: List<Question>.from(json["Questions"].map((x) => Question.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    };
}

class Question {
    Question({
        required this.questionId,
        required this.answer,
    });

    String questionId;
    String answer;

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["questionId"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "answer": answer,
    };
}
