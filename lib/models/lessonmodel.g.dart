// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessonmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
      id: json['id'] as String,
      description: json['description'] as String,
      question:
          QuestionModel.fromJson(json['question'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'question': instance.question.toJson(),
    };
