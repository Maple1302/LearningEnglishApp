// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_pair_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchingPairQuestion _$MatchingPairQuestionFromJson(
        Map<String, dynamic> json) =>
    MatchingPairQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$MatchingPairQuestionToJson(
        MatchingPairQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'items': instance.items,
    };
