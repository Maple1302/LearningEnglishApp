// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PronunciationQuestion _$PronunciationQuestionFromJson(
        Map<String, dynamic> json) =>
    PronunciationQuestion(
      typeOfQuestion:
          json['typeOfQuestion'] as String? ?? pronunciationQuestion,
      sampleText: json['sampleText'] as String,
      mean: json['mean'] as String,
    );

Map<String, dynamic> _$PronunciationQuestionToJson(
        PronunciationQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'sampleText': instance.sampleText,
      'mean': instance.mean,
    };
