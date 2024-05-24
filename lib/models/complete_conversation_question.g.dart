// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_conversation_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteConversationQuestion _$CompleteConversationQuestionFromJson(
        Map<String, dynamic> json) =>
    CompleteConversationQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      question: Map<String, String>.from(json['question'] as Map),
      correctAnswer: Map<String, String>.from(json['correctAnswer'] as Map),
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CompleteConversationQuestionToJson(
        CompleteConversationQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'items': instance.items,
    };
