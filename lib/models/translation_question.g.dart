// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationScreen _$TranslationScreenFromJson(Map<String, dynamic> json) =>
    TranslationScreen(
      typeOfQuestion: json['typeOfQuestion'] as String,
      question: json['question'] as String,
      mean: json['mean'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$TranslationScreenToJson(TranslationScreen instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'question': instance.question,
      'mean': instance.mean,
      'answers': instance.answers,
      'type': instance.type,
    };
