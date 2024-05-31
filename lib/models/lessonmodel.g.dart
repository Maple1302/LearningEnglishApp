// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessonmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      question: (json['question'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: json['images'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'question': instance.question.map((e) => e.toJson()).toList(),
      'images': instance.images,
      'color': instance.color,
    };
