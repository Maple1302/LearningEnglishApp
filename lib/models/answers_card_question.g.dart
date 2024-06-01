// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_card_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswersCardQuestion _$AnswersCardQuestionFromJson(Map<String, dynamic> json) =>
    AnswersCardQuestion(
      typeOfQuestion:
          json['typeOfQuestion'] as String? ?? cardMutilChoiceQuestion,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AnswersCardQuestionToJson(
        AnswersCardQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'answers': instance.answers,
    };
