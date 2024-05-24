// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListeningQuestion _$ListeningQuestionFromJson(Map<String, dynamic> json) =>
    ListeningQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      correctAnswer: json['correctAnswer'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ListeningQuestionToJson(ListeningQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'correctAnswer': instance.correctAnswer,
      'items': instance.items,
    };
