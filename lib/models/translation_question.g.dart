// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationQuestion _$TranslationQuestionFromJson(Map<String, dynamic> json) =>
    TranslationQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      question: json['question'] as String,
      mean: json['mean'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TranslationQuestionToJson(
        TranslationQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'question': instance.question,
      'mean': instance.mean,
      'answers': instance.answers,
    };
