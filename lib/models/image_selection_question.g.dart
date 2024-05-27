// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_selection_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageSelectionQuestion _$ImageSelectionQuestionFromJson(
        Map<String, dynamic> json) =>
    ImageSelectionQuestion(
      typeOfQuestion: json['typeOfQuestion'] as String,
      expectedWord: json['expectedWord'] as String,
      correctAnswer: json['correctAnswer'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$ImageSelectionQuestionToJson(
        ImageSelectionQuestion instance) =>
    <String, dynamic>{
      'typeOfQuestion': instance.typeOfQuestion,
      'expectedWord': instance.expectedWord,
      'correctAnswer': instance.correctAnswer,
      'items': instance.items,
    };
