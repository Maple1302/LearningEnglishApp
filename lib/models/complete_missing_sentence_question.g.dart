// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_missing_sentence_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteMissingSentenceQuestion _$CompleteMissingSentenceQuestionFromJson(
        Map<String, dynamic> json) =>
    CompleteMissingSentenceQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      expectedSentence: json['expectedSentence'] as String,
      missingSentence: json['missingSentence'] as String,
      correctanswers: json['correctanswers'] as String,
    );

Map<String, dynamic> _$CompleteMissingSentenceQuestionToJson(
        CompleteMissingSentenceQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'expectedSentence': instance.expectedSentence,
      'missingSentence': instance.missingSentence,
      'correctanswers': instance.correctanswers,
    };
